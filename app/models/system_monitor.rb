class SystemMonitor

  # determine if apache is running
  def self.apache
    apache_output = GlobalSettings.apache_status
    apache_output =~ /pid/
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
    beef_output = `ps aux | grep beef | grep -v color`
    beef_output =~ /beef/
  end

  def self.sidekiq
    begin
      pid_file = File.expand_path(File.join(Rails.root, 'tmp', 'pids', 'sidekiq.pid'))
      pid = File.read(pid_file)
      Process.getpgid(pid.to_i)
    rescue Exception => e
      Rails.logger.error e
      false
    end
  end
end