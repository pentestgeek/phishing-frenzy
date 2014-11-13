class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_admin!
  before_filter :system_status

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username) }
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
