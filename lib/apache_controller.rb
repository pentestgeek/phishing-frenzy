module ApacheController
  APACHE_STATUS_COMMAND = '/etc/init.d/apache2 status'
  APACHE_RESTART_COMMAND = 'sudo /etc/init.d/apache2 reload'
  APACHE_VHOSTS_COMMAND = 'apache2ctl -S'
  APACHE_CONFIG_PATH = '/etc/apache2/'

  def self.running?
    !!(`#{APACHE_STATUS_COMMAND} 2>&1` =~ /pid/)
  end

  def self.vhosts
    vhosts_output = `#{APACHE_VHOSTS_COMMAND} 2>&1`
    if vhosts_output.blank?
      []
    else
      vhosts_output.split(/\r?\n/)[3..20]
    end
  end

  def self.config_path
    APACHE_CONFIG_PATH
  end

  def self.sites_enabled_path
    File.join(APACHE_CONFIG_PATH, 'sites-enabled')
  end

  def self.sites_available_path
    File.join(APACHE_CONFIG_PATH, 'sites-available')
  end

  def self.vhost_file_path(id)
    File.join(sites_available_path, "#{id}.conf")
  end

  def self.sites_path_writable
    # ensure we have write access to sites-*
    errors = []
    unless File.writable?(sites_available_path)
      access = false
      errors << [:apache, "File Permission Issue: chmod -R 755 and chown www-data:www-data #{sites_available_path}"]
    end

    unless File.writable?(sites_enabled_path)
      access = false
      errors << [:apache, "File Permission Issue: chmod -R 755 and chown www-data:www-data #{sites_enabled_path}"]
    end

    errors
  end

  def self.log(message)
    Rails.logger.info "APACHE: #{message}"
  end

  def self.enable_site(id)
    log `a2ensite #{id}.conf 2&>1`
  end

  def self.disable_site(id)
    log `a2dissite #{id}.conf 2&>1`
  end

  def self.reload
    log `#{APACHE_RESTART_COMMAND} 2&>1`
  end

  def self.rm_vhost_file(id)
    FileUtils.rm_rf vhost_file_path(id) if File.exists?(vhost_file_path(id))
  end
end
