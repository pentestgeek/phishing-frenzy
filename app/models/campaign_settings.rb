class CampaignSettings < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible :track_uniq_visitors, :track_hits, :iptable_restrictions, :schedule_campaign, :use_beef, :beef_url, :campaign_id, :fqdn, :smtp_delay, :ssl

  def smtp_delays
    [0,5,10,15,30,60].map { |s| ["%d seconds" % s, s]}
  end

end
