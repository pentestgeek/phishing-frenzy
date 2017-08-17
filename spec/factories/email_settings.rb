# == Schema Information
#
# Table name: email_settings
#
#  id                   :integer          not null, primary key
#  campaign_id          :integer
#  to                   :string(255)
#  cc                   :string(255)
#  bcc                  :string(255)
#  from                 :string(255)
#  display_from         :string(255)
#  subject              :string(255)
#  phishing_url         :string(255)
#  smtp_server          :string(255)
#  smtp_server_out      :string(255)
#  smtp_port            :integer
#  smtp_username        :string(255)
#  smtp_password        :string(255)
#  emails_sent          :integer          default(0)
#  created_at           :datetime
#  updated_at           :datetime
#  openssl_verify_mode  :string(255)
#  domain               :string(255)
#  authentication       :string(255)
#  enable_starttls_auto :boolean
#  reply_to             :string(255)
#

FactoryGirl.define do
  factory :email_settings, :class => 'EmailSettings' do
    campaign
    to                  { Faker::Internet.email }
    cc                  { Faker::Internet.email }
    bcc                 { Faker::Internet.email }
    from                { Faker::Internet.email }
    display_from        { Faker::Internet.email }
    sequence(:subject)  {|n| "Subject #{n}"}
    sequence(:phishing_url) {|n| "sub#{n}.phishingfrenzy.local" }
    smtp_server "smtp.secureserver.net"
    smtp_server_out "smtpout.secureserver.net"
    smtp_port 3535
    sequence(:smtp_username) {|n| "from#{n}@phishingfrenzy.local"}
    sequence(:smtp_password) {|n| "SecretPasswd321!"}
  end

end
