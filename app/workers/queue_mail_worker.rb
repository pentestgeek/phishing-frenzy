class QueueMailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    if campaign.errors.present?
      logger.info "Unable to launch campaign #{campaign_id} as errors are present."
      return false
    end
    campaign.update_attributes(active: true, email_sent: true)
    blast = campaign.blasts.create(test: false)
    victims = Victim.where("campaign_id = ? and archive = ?", campaign_id, false)
    logger.info "Queueing #{victims.count} emails for background delivery for campaign #{campaign_id}"
    victims.each do |target|
      MailWorker.perform_async(campaign.id, target.email_address, blast.id, PhishingFrenzyMailer::ACTIVE)
    end
  end
end
