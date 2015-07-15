class MailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(campaign_id, launch = true)
    @campaign = Campaign.find_by_id(campaign_id)
    @blast = @campaign.blasts.create(test: !launch)
    @mailer = CampaignMailer.new(@campaign, @blast)

    if launch
      if @mailer.valid? and @mailer.victims_valid?
        @mailer.launch!
      end
      @blast.message = @mailer.messages
    else
      unless @mailer.valid? and not @mailer.test_victim_valid?
        @blast.message = "#{@mailer.messages.join(". ")}"
      end
      if @mailer.test!
        @blast.message = "#{@mailer.messages.join(". ")}"
      else
        @blast.message = "Email has failed"
      end
    end
    @blast.save
  end
end