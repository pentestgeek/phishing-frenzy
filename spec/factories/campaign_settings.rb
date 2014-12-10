FactoryGirl.define do
  factory :campaign_settings, :class => 'CampaignSettings' do
  	campaign
    sequence(:fqdn) {|n| "sub#{n}.phishingfrenzy.local"}
    ssl false
    beef_url "http://phishingfrenzy.local:3000/hook.js" 
  end

end
