# == Schema Information
#
# Table name: global_settings
#
#  id                     :integer          not null, primary key
#  command_apache_restart :string(255)
#  smtp_timeout           :integer          default(5)
#  created_at             :datetime
#  updated_at             :datetime
#  command_apache_status  :string(255)
#  command_apache_vhosts  :string(255)      default("apache2ctl -S")
#  asynchronous           :boolean          default(TRUE)
#  bing_api               :string(255)
#  beef_url               :string(255)
#  sites_enabled_path     :string(255)      default("/etc/apache2/sites-enabled")
#  reports_refresh        :integer          default(15)
#  site_url               :string(255)      default("https://phishingfrenzy.local")
#

class GlobalSettings < ActiveRecord::Base

  attr_accessible :site_url, :command_apache_restart, :command_apache_vhosts, :command_apache_status, :sites_enabled_path, :smtp_timeout, :asynchronous, :bing_api, :beef_url, :reports_refresh

  validates :site_url, uri: true
  validates :command_apache_restart, :presence => true, :length => {:maximum => 255}
  validates :command_apache_vhosts, :presence => true, :length => {:maximum => 255}
  validates :sites_enabled_path, :presence => true, :length => {:maximum => 255}
  validates :smtp_timeout, :presence => true, :length => {:maximum => 2},
            :numericality => {:greater_than_or_equal_to => 1, :less_than_or_equal_to => 20}

  def self.asynchronous?
    first.asynchronous?
  end

  def self.apache_status
    `#{first.command_apache_status} 2>&1`
  end

  def self.apache_vhosts
    vhosts_output = `#{first.command_apache_vhosts} 2>&1`
    if vhosts_output.blank?
      []
    else
      vhosts_output.split("\n")[1..20]
    end
  end

end

