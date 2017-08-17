# == Schema Information
#
# Table name: campaign_settings
#
#  id                     :integer          not null, primary key
#  campaign_id            :integer
#  fqdn                   :string(255)
#  phishing_url           :string(255)
#  apache_directory_root  :string(255)
#  apache_directory_index :string(255)
#  track_uniq_visitors    :boolean          default(TRUE)
#  track_hits             :boolean          default(TRUE)
#  iptable_restrictions   :boolean          default(FALSE)
#  schedule_campaign      :boolean          default(FALSE)
#  use_beef               :boolean          default(FALSE)
#  created_at             :datetime
#  updated_at             :datetime
#  smtp_delay             :integer          default(0)
#  beef_url               :string(255)
#  ssl                    :boolean
#  require_uid            :boolean          default(TRUE)
#  password_storage       :boolean          default(TRUE)
#

class CampaignSettings < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible :track_uniq_visitors, :track_hits, :iptable_restrictions, :schedule_campaign,
  	:use_beef, :beef_url, :campaign_id, :fqdn, :smtp_delay, :ssl, :password_storage, :require_uid

  def smtp_delays
    [0,5,10,15,30,60].map { |s| ["%d seconds" % s, s]}
  end

end
