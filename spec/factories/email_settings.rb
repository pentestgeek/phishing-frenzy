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
