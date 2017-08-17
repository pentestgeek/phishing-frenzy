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

FactoryGirl.define do
  factory :campaign_settings, :class => 'CampaignSettings' do
  	campaign
    fqdn { Faker::Internet.domain_name }
    beef_url { Faker::Internet.url }
    ssl false
  end

end
