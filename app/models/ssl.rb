class Ssl < ActiveRecord::Base
  belongs_to :campaign

  #validates_presence_of :filename
  validates :function, uniqueness: true

  attr_accessible :filename, :function
  mount_uploader :filename, FileUploader

  def self.functions
    [['SSLCertificateFile', 'SSLCertificateFile'],
    ['SSLCertificateKeyFile','SSLCertificateKeyFile'],
    ['SSLCertificateChainFile','SSLCertificateChainFile']]
  end
end
