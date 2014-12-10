class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_admin!
  before_filter :system_status

  add_flash_types :warning

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :name, :email, :password, :password_confirmation, :current_password) }
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
        flash[:warning] = "You have #{ActionController::Base.helpers.pluralize(q, 'job')} enqueued, but sidekiq is not running"
      end
    rescue Redis::CannotConnectError => e
      @redis = false
    end
  end

end
