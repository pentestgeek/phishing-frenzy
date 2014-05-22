class EmailSettings < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible :campaign_id, :to, :cc, :bcc, :from, :display_from, :subject, :phishing_url,
                  :smtp_server, :smtp_username, :smtp_password, :smtp_port, :smtp_server_out,
                  :openssl_verify_mode, :domain, :authentication, :enable_starttls_auto

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
