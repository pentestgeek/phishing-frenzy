class EmailController < ApplicationController
  TEST = false
  ACTIVE = true

  def index
    send_email
    render('send')
  end

  def send_email
    if GlobalSettings.asynchronous?
      begin
        MailWorker.perform_async(params[:id], TEST)
        flash[:notice] = "Campaign test email queued"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      MailWorker.new.perform(params[:id], TEST)
      flash[:notice] = "Campaign test email sent"
    end
    redirect_to :back
  end

  def launch_email
    if GlobalSettings.asynchronous?
      begin
        MailWorker.perform_async(params[:id], ACTIVE)
        flash[:notice] = "Campaign blast launched"
      rescue Redis::CannotConnectError => e
        flash[:error] = "Sidekiq cannot connect to Redis. Emails were not queued."
      end
    else
      MailWorker.new.perform(params[:id], ACTIVE)
      flash[:notice] = "Campaign blast launched"
    end
    redirect_to :back
  end
end
