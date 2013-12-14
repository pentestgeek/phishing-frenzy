class GlobalSettings < ActiveRecord::Base

  attr_accessible :command_apache_restart, :command_apache_vhosts, :command_apache_status, :path_apache_httpd, :smtp_timeout

  validates :command_apache_restart, :presence => true, :length => {:maximum => 255}
  validates :command_apache_vhosts, :presence => true, :length => {:maximum => 255}
  validates :path_apache_httpd, :presence => true, :length => {:maximum => 255}
  validates :smtp_timeout, :presence => true, :length => {:maximum => 2},
            :numericality => {:greater_than_or_equal_to => 1, :less_than_or_equal_to => 20}

  def self.asynchronous?
    first.asynchronous?
  end

  def self.apache_status
    `#{first.command_apache_status}`
  end

  def self.apache_vhosts
    vhosts_output = `#{first.command_apache_vhosts}`
    if vhosts_output.blank?
      []
    else
      vhosts_output.split("\n")[3..20]
    end
  end
end
