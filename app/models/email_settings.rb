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

class EmailSettings < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible :campaign_id, :to, :cc, :bcc, :from, :display_from, :subject, :phishing_url,
                  :smtp_server, :smtp_username, :smtp_password, :smtp_port, :smtp_server_out,
                  :openssl_verify_mode, :domain, :authentication, :enable_starttls_auto, :reply_to

  validates :campaign_id, :presence => true,
            :length => {:maximum => 255}
  validates :display_from,
            :length => {:maximum => 255}, :allow_nil => true
  validates :subject,
            :length => {:maximum => 255}, :allow_nil => true
  validates :smtp_server,
            :length => {:maximum => 255}, :allow_nil => true
  validates :smtp_server_out,
            :length => {:maximum => 255}, :allow_nil => true
  validates :smtp_username,
            :length => {:maximum => 255}, :allow_nil => true
  validates :smtp_password,
            :length => {:maximum => 255}, :allow_nil => true
  validates :smtp_port, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 65535},
            :length => {:maximum => 5}, :allow_nil => true

  def authentications
    [:plain, :login, :cram_md5, :none]
  end

  def openssl_verify_modes
    %w(VERIFY_NONE VERIFY_PEER VERIFY_CLIENT_ONCE VERIFY_FAIL_IF_NO_PEER_CERT)
  end

  def openssl_verify_mode_class
    m = {
      'VERIFY_NONE' => OpenSSL::SSL::VERIFY_NONE,
      'VERIFY_PEER' => OpenSSL::SSL::VERIFY_PEER,
      'VERIFY_CLIENT_ONCE' => OpenSSL::SSL::VERIFY_CLIENT_ONCE,
      'VERIFY_FAIL_IF_NO_PEER_CERT' => OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT
    }
    m[openssl_verify_mode]
  end

end
