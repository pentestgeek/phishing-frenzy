class QueueMailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    if campaign.errors.present?
      logger.error "Unable to queue emails for delivery - errors present in campaign #{campaign_id}"
      return false
    end

    campaign.update_attributes(active: true, email_sent: true)
    blast = campaign.blasts.create(test: false)
    victims = Victim.where("campaign_id = ? and archive = ?", campaign_id, false)
    logger.info "Queueing #{victims.count} emails for background delivery for campaign #{campaign_id}"
    victims.each do |target|
      begin
        PhishingFrenzyMailer.phish(campaign.id, target.email_address, blast.id, PhishingFrenzyMailer::ACTIVE)
      rescue Exception => e
        logger.error "Exception sending email to #{target.email_address}, Campaign ID:#{campaign_id} - #{e}"
      end
    end
  end
end
