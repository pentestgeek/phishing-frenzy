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

require 'test_helper'

class EmailSettingsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
