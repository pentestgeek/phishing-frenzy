class MailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(campaign_id, target, blast_id, method)
    logger.info "Attempting to send mail: campaign_id #{campaign_id}, target #{target}, blast_id #{blast_id}"
    begin
      PhishingFrenzyMailer.phish(campaign_id, target, blast_id, method).message
    rescue => e
      logger.error "Failed to send mail: campaign_id #{campaign_id}, target #{target}, blast_id #{blast_id} - #{e.message}"
      raise
    end
  end
end
