class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_admin!
  before_filter :system_status

  add_flash_types :warning

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :email, :password, :password_confirmation, :current_password])
  end

  def system_status
    @show_status = true
    @apache = SystemMonitor.apache
    @vhosts = SystemMonitor.vhosts
    @msf = SystemMonitor.metasploit
    @beef = SystemMonitor.beef
    @sidekiq = SystemMonitor.sidekiq
    begin
      q = Sidekiq::Stats.new.enqueued
      @redis = true
      if q > 0 and !@sidekiq
        flash[:warning] = "You have #{ActionController::Base.helpers.pluralize(q, 'job')} enqueued, but Sidekiq is not running"
      end
    rescue Redis::CannotConnectError => e
      logger.error e.message
      @redis = false
      flash[:warning] = e.message if e.message =~ /timeout/i
    end
  end

end
