FactoryGirl.define do
  factory :email_settings, :class => 'EmailSettings' do
    campaign
    sequence(:to)	{|n| "email#{n}@phishingfrenzy.local"}
    sequence(:cc)	{|n| "emailcc#{n}@phishingfrenzy.local"}
    sequence(:bcc)	{|n| "emailbcc#{n}@phishingfrenzy.local"}
    sequence(:from)	{|n| "from#{n}@phishingfrenzy.local"}
    sequence(:display_from)	{|n| "Display From #{n}"}
    sequence(:subject)	{|n| "Subject #{n}"}
    sequence(:phishing_url) {|n| "sub#{n}.phishingfrenzy.local" }
    smtp_server "smtp.secureserver.net"
    smtp_server_out "smtpout.secureserver.net"
    smtp_port 3535
    sequence(:smtp_username) {|n| "from#{n}@phishingfrenzy.local"}
    sequence(:smtp_password) {|n| "SecretPasswd321!"}
  end

end
