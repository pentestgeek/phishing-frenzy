class Ssl < ActiveRecord::Base
  belongs_to :campaign

  validates_uniqueness_of :function, scope: :campaign_id
  before_validation :validate_certificates

  attr_accessible :filename, :function
  mount_uploader :filename, FileUploader

  def self.functions
    [['SSLCertificateFile', 'SSLCertificateFile'],
    ['SSLCertificateKeyFile','SSLCertificateKeyFile'],
    ['SSLCertificateChainFile','SSLCertificateChainFile']]
  end

  private

    def validate_certificates
      # if function SSLcert
      if function == "SSLCertificateFile"
        unless validate_certificate_file
          errors.add(:function, "SSLCertificateFile is an invalid certificate")
        end
      end

      # if function SSLKeycert
      if function == "SSLCertificateKeyFile"
        unless validate_certificate_key_file
          errors.add(:function, "SSLCertificateKeyFile is an invalid key file")
        end
      end

      # if function SSLKeycert
      if function == "SSLCertificateChainFile"
        unless validate_certificate_chain_file
          errors.add(:function, "SSLCertificateChainFile is an invalid chain file")
        end
      end
      return errors
    end

    def validate_certificate_file
      begin
        OpenSSL::X509::Certificate.new filename.read
      rescue
        return false
      end
      return true
    end

    def validate_certificate_key_file
      begin
        OpenSSL::PKey::RSA.new filename.read
      rescue
        return false
      end
      return true
    end

    def validate_certificate_chain_file
      begin
        OpenSSL::X509::Certificate.new filename.read
      rescue
        return false
      end
      return true
    end
end
