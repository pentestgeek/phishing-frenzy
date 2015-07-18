require 'apache_controller'

def silence_warnings(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    result = block.call
    $VERBOSE = warn_level
    result
end

silence_warnings do
  ApacheController::APACHE_STATUS_COMMAND = '/etc/init.d/apache2 status'
  ApacheController::APACHE_RESTART_COMMAND = 'sudo /etc/init.d/apache2 reload'
  ApacheController::APACHE_VHOSTS_COMMAND = 'apache2ctl -S'
  ApacheController::APACHE_CONFIG_PATH = '/etc/apache2/'
end
