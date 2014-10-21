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
      rescue::NoMethodError => e
        flash[:error] = "Template Issue: #{e}"
      end
    else
      begin
        PhishingFrenzyMailer.phish(@campaign.id, @campaign.test_victim.email_address, @blast.id, PREVIEW)
        flash[:notice] = "Campaign test email available for preview"
      rescue::NoMethodError => e
        flash[:error] = "Template Issue: #{e}"
      end
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
      rescue::NoMethodError => e
        flash[:error] = "Template Issue: #{e}"
      end
    else
      begin
        PhishingFrenzyMailer.phish(@campaign.id, @campaign.test_victim.email_address, @blast.id, ACTIVE)
        flash[:notice] = "Campaign test email sent"
      rescue => e
        flash[:error] = "Template Issue: #{e}"
      end
    end
    redirect_to :back
  end

  def launch
    @campaign = Campaign.find(params[:id])
    @campaign.update_attributes(active: true)
    @blast = @campaign.blasts.create(test: false)
    victims = Victim.where("campaign_id = ? and archive = ? and sent = ?", params[:id], false, false)
    if GlobalSettings.asynchronous?
      begin
        victims.each do |target|
          PhishingFrenzyMailer.delay.phish(@campaign.id, target, @blast.id, ACTIVE)
          target.update_attribute(:sent, true)
        end
        @campaign.email_sent = true
        @campaign.save
        flash[:notice] = "Campaign blast launched"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      rescue::NoMethodError => e
        flash[:error] = "Template Issue: #{e}"
      end
    else
      begin
        victims.each do |target|
          PhishingFrenzyMailer.phish(@campaign.id, target, @blast, ACTIVE)
          target.update_attribute(:sent, true)
        end
        flash[:notice] = "Campaign blast launched"
        @campaign.email_sent = true
        @campaign.save
      rescue::NoMethodError => e
        flash[:error] = "Template Issue: #{e}"
      end
    end
    redirect_to :back

  end
end
