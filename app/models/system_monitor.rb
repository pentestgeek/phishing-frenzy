class SystemMonitor

  # determine if apache is running
  def self.apache
    apache_output = GlobalSettings.apache_status
    apache_output =~ /pid|(running)/
  end

  # determine if any VHOST are configured
  def self.vhosts
    GlobalSettings.apache_vhosts
  end

  # determine if metasploit is running
  def self.metasploit
    msf_output = `ps aux | grep msf`
    msf_output =~ /msfconsole/
  end

  # determine if BeeF is running
  def self.beef
    beef_output = `ps aux | grep '[b]eef'`
    beef_output =~ /beef/
  end

  def self.sidekiq
    begin
      pid_file = File.expand_path(File.join(Rails.root, 'tmp', 'pids', 'sidekiq.pid'))
      pid = File.read(pid_file)
      Process.getpgid(pid.to_i)
    rescue Exception => e
      Rails.logger.error %Q(Sidekiq is not running, or pid file, '#{pid_file}' is invalid:
      #{e.class} - #{e.message})
      false
    end
  end
end
