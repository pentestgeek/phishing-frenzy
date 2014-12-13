FactoryGirl.define do
  factory :campaign_settings, :class => 'CampaignSettings' do
  	campaign
    fqdn { Faker::Internet.domain_name }
    beef_url { Faker::Internet.url }
    ssl false
  end

end
