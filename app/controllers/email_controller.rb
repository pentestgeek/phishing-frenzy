class EmailController < ApplicationController
  TEST = false
  ACTIVE = true

  def index
    send_email
    render('send')
  end

  def send_email
    MailWorker.perform_async(params[:id], TEST)
    flash[:notice] = "Campaign test email sent"
    redirect_to :back

	end
	def launch_email
    MailWorker.perform_async(params[:id], ACTIVE)
    flash[:notice] = "Campaign blast launched"
    redirect_to :back
	end
end
