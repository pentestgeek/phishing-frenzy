class Blast < ActiveRecord::Base
  attr_accessible :campaign_id, :emails_sent, :message, :number_of_targets, :test
  belongs_to :campaign

  def email_delivered!
    Blast.increment_counter(:emails_sent, self.id)
  end
end

