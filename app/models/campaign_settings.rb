class CampaignSettings < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible :track_uniq_visitors, :track_hits, :iptable_restrictions, :schedule_campaign, :use_beef, :campaign_id, :fqdn

end
