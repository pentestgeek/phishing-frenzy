class EmailController < ApplicationController

  def index
    send_email
    render('send')
  end

  def test_delivery(action, redirect, async_success_notice, sync_success_notice)
    campaign = Campaign.find(params[:id])
    blast = campaign.blasts.create(test: true)
    begin
      # There is no reason we would want to queue a preview.
      if GlobalSettings.asynchronous? && action != PhishingFrenzyMailer::PREVIEW
        MailWorker.perform_async(campaign.id, campaign.test_victim.email_address, blast.id, action)
        flash[:notice] = async_success_notice
      else
        PhishingFrenzyMailer.phish(campaign.id, campaign.test_victim.email_address, blast.id, action)
        flash[:notice] = sync_success_notice
      end
    rescue Redis::CannotConnectError => e
      flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
    rescue::NoMethodError
      flash[:error] = "Template is missing an email file, upload and create new email"
    rescue => e
      flash[:error] = "Generic Template Issue: #{e}"
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
    campaign = Campaign.find(params[:id])
    if campaign.errors.present?
      render template: "/campaigns/show"
      return false
    end
    campaign.update_attributes(active: true, email_sent: true)
    blast = campaign.blasts.create(test: false)
    victims = Victim.where("campaign_id = ? and archive = ?", params[:id], false)
    begin
      async = GlobalSettings.asynchronous?
      victims.each do |target|
        if async
          MailWorker.perform_async(campaign.id, target.email_address, blast.id, PhishingFrenzyMailer::ACTIVE)
        else
          PhishingFrenzyMailer.phish(campaign.id, target.email_address, blast.id, PhishingFrenzyMailer::ACTIVE)
        end
        target.update_attribute(:sent, true)
      end
      flash[:notice] = "Campaign blast launched"
    rescue Redis::CannotConnectError => e
      flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
    rescue::NoMethodError
      flash[:error] = "Template is missing an email file, upload and create new email"
    rescue => e
      flash[:error] = "Generic Template Issue: #{e}"
    end

    redirect_to :back
  end

end
