class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_admin!
  before_filter :system_status
  before_filter :queue_status

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username) }
  end

  def system_status
    @apache = SYSTEM_MONITOR.apache
    @vhosts = SYSTEM_MONITOR.vhosts
    @msf = SYSTEM_MONITOR.metasploit
    @beef = SYSTEM_MONITOR.beef
    @sidekiq = SYSTEM_MONITOR.sidekiq
  end

  def queue_status
    begin
      q = Sidekiq::Stats.new.enqueued
      if q > 0 and !@sidekiq
        flash[:warning] = "You have #{ActionController::Base.helpers.pluralize(q, 'job')} enqueued, but sidekiq is not running"
      end
    rescue Redis::CannotConnectError => e
      flash[:warning] = "Sidekiq cannot connect to Redis"
    end
  end


end
