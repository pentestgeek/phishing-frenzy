class EmailController < ApplicationController
  PREVIEW = 0
  ACTIVE = 1


  def index
    send_email
    render('send')
  end

  def preview
    @campaign = Campaign.find(params[:id])
    @blast = @campaign.blasts.create(test: true)
    if GlobalSettings.asynchronous?
      begin
        PhishingFrenzyMailer.delay.phish(@campaign.id, @campaign.test_victim.email_address, @blast.id, PREVIEW)
        flash[:notice] = "Campaign test email queued for preview"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      PhishingFrenzyMailer.phish(@campaign.id, @campaign.test_victim.email_address, @blast.id, PREVIEW)
      flash[:notice] = "Campaign test email available for preview"
    end
    redirect_to "/letter_opener"
  end

  def test
    @campaign = Campaign.find(params[:id])
    @blast = @campaign.blasts.create(test: true)
    if GlobalSettings.asynchronous?
      begin
        PhishingFrenzyMailer.delay.phish(@campaign.id, @campaign.test_victim.email_address, @blast.id, ACTIVE)
        flash[:notice] = "Campaign test email queued for test"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      PhishingFrenzyMailer.phish(@campaign.id, @campaign.test_victim.email_address, @blast.id, ACTIVE)
      flash[:notice] = "Campaign test email sent"
    end
    redirect_to :back
  end

  def launch
    @campaign = Campaign.find(params[:id])
    @campaign.update_attributes(active: true)
    @blast = @campaign.blasts.create(test: false)
    if GlobalSettings.asynchronous?
      begin
        @campaign.victims.each do |target|
          PhishingFrenzyMailer.delay.phish(@campaign.id, target.email_address, @blast.id, ACTIVE)
        end
        flash[:notice] = "Campaign blast launched"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      @campaign.victims.each do |target|
        PhishingFrenzyMailer.phish(@campaign.id, target.email_address, @blast, ACTIVE)
      end
      flash[:notice] = "Campaign blast launched"
      @campaign.email_sent = true
      @campaign.save
    end
    redirect_to :back

  end
end
