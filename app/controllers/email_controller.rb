class EmailController < ApplicationController
	before_filter :confirm_logged_in

	def index
		send_email
		render('send')
	end

	def send_email
	@campaign = Campaign.find_by_id(params[:id])
	@mailer = CampaignMailer.new(@campaign)

		unless @mailer.valid?
			flash[:notice] = "#{@mailer.messages.join(". ")}"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
			return false
		end

		if @mailer.test!
			flash[:notice] = "#{@mailer.messages.join(". ")}"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
		else
			flash[:notice] = "Test email has failed"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
			return false		
		end
	end

	def launch_email
	@campaign = Campaign.find_by_id(params[:id])
	@mailer = CampaignMailer.new(@campaign)
	if @mailer.valid? and @mailer.victims_valid?
		@mailer.launch!
		@messages = @mailer.messages
		flash[:notice] = "Campaign Launched"
		render('send')
	else
		flash[:notice] = "#{@mailer.messages.join(". ")}"
		redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
		end
	end
end
