class EmailController < ApplicationController
  TEST = false
  ACTIVE = true

  def index
    send_email
    render('send')
  end

  def send_email
    @campaign = Campaign.find(params[:id])
    if GlobalSettings.asynchronous?
      begin
        PhishingFrenzyMailer.delay.intel(@campaign.id, @campaign.test_victim.email_address, TEST)
        flash[:notice] = "Campaign test email queued for preview"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      PhishingFrenzyMailer.intel(@campaign.id, @campaign.test_victim.email_address, TEST).deliver
      flash[:notice] = "Campaign test email available for preview"
    end
    redirect_to :back
  end

  def launch_email
    @campaign = Campaign.find(params[:id])
    if GlobalSettings.asynchronous?
      begin
        @campaign.victims.each do |target|
          PhishingFrenzyMailer.delay.intel(@campaign.id, target, ACTIVE)
        end
        flash[:notice] = "Campaign blast launched"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      @campaign.victims.each do |target|
        PhishingFrenzyMailer.intel(@campaign.id, target.email_address, ACTIVE).deliver
      end
      flash[:notice] = "Campaign blast launched"
    end
    redirect_to :back
  end
end
