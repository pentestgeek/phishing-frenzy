class EmailController < ApplicationController
  before_action :set_campaign, only: [:test, :launch, :preview]
  before_action :template_email_exists?, only: [:test, :launch, :preview]

  def index
    send_email
    render('send')
  end

  def test_delivery(action, redirect, async_success_notice, sync_success_notice)
    blast = @campaign.blasts.create(test: true)
    # There is no reason we would want to queue a preview.
    if GlobalSettings.asynchronous? && action != PhishingFrenzyMailer::PREVIEW
      begin
        MailWorker.perform_async(@campaign.id, @campaign.test_victim.email_address, blast.id, action)
        flash[:notice] = async_success_notice
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      begin
        PhishingFrenzyMailer.phish(@campaign.id, @campaign.test_victim.email_address, blast.id, action).message
        flash[:notice] = sync_success_notice
      rescue::NoMethodError
        flash[:error] = "Template is missing an email file, upload and create new email"
      rescue => e
        flash[:error] = "Generic Template Issue: #{e}"
      end
    end

    redirect_to redirect
  end

  def preview
    test_delivery(PhishingFrenzyMailer::PREVIEW,
                  "/letter_opener",
                  "Campaign test email queued for preview",
                  "Campaign test email available for preview")
  end

  def test
    test_delivery(PhishingFrenzyMailer::ACTIVE,
                  :back,
                  "Campaign test email queued for test",
                  "Campaign test email sent")
  end

  def launch
    if @campaign.errors.present?
      render template: "/campaigns/show"
      return false
    end

    if GlobalSettings.asynchronous?
      logger.info "Queueing emails for background delivery for campaign #{params[:id]}"
      QueueMailWorker.perform_async(params[:id])
    else
      @campaign.update_attributes(active: true, email_sent: true)
      blast = @campaign.blasts.create(test: false)
      victims = Victim.where("campaign_id = ? and archive = ?", params[:id], false)

      victims.each do |target|
        begin
          PhishingFrenzyMailer.phish(@campaign.id, target.email_address, blast.id, PhishingFrenzyMailer::ACTIVE).message
        rescue ::NoMethodError
          flash[:error] = "Template is missing an email file, upload and create new email"
          break
        rescue Exception => e
          flash[:error] = "Generic Template Issue: #{e}"
          break
        end
      end
    end

    flash[:notice] = "Campaign blast launched"
    redirect_to :back
  end

  private

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def template_email_exists?
      # validate that we have an email in the template to send
      if @campaign.template.present? && @campaign.template.email_files.present?
        return true # we have an email file within the template
      else
        flash[:error] = "Template is missing an email file, upload and create new email"
        redirect_to :back
        return false # no email template within the template
      end
    end
end
