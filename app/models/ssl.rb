class Ssl < ActiveRecord::Base
  belongs_to :campaign

  validates_uniqueness_of :function, scope: :campaign_id

  attr_accessible :filename, :function
  mount_uploader :filename, FileUploader

  def self.functions
    [['SSLCertificateFile', 'SSLCertificateFile'],
    ['SSLCertificateKeyFile','SSLCertificateKeyFile'],
    ['SSLCertificateChainFile','SSLCertificateChainFile']]
  end
end
