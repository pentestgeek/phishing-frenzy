class CampaignsController < ApplicationController
	before_filter :confirm_logged_in
	
	def index
		list
		render('list')
	end

	def list
		# grab the campaigns and sort by id
		@campaigns = Campaign.order("campaigns.id ASC")
	end

	def home
		# grab only the active campaigns
		@campaigns = Campaign.active

		# determine if apache is running
		apache_output = `service apache2 status`
		if apache_output =~ /pid/
			@apache = true
		else
			@apache = false
		end

		# determine if any VHOST are configured
		vhosts_output = `apache2ctl -S`
		if vhosts_output.blank?
			@vhosts = []
		else 
			@vhosts = vhosts_output.split("\n")[3..20]
		end
		# determine if metasploit is running
		msf_output = `ps aux | grep msf`
		if msf_output =~ /msfconsole/
			@msf = true
		else
			@msf = false
		end

		# determine if BeeF is running
		beef_output = `ps aux | grep beef`
		if beef_output =~ /beef.py/
			@beef = true
		else
			@beef = false
		end
	end

	def show
		@campaign = Campaign.find_by_id(params[:id])
		if @campaign.nil?
			list
			render('list')
		end
	end

	def new
		@campaign = Campaign.new
	end

	def create 
		@campaign = Campaign.new(params[:campaign])
		if @campaign.save 
			@campaign_settings = CampaignSettings.new(:campaign_id => @campaign.id, :fqdn => '')
			@email_settings = EmailSettings.new(:campaign_id => @campaign.id)
			if @campaign_settings.save and @email_settings.save
				flash[:notice] = "Campaign Created"
				redirect_to(:action => 'list')
			else
				render('new')
			end

		else
			render('new')
		end
	end

	def edit
		# find existing id
		@campaign = Campaign.find_by_id(params[:id])
		if @campaign.nil?
			list
			render('list')
		end
	end

	def update
		@campaign = Campaign.find(params[:id])
		if @campaign.update_attributes(params[:campaign])
			flash[:notice] = "Campaign Updated"
			redirect_to(:action => 'list')
		else
			render('edit')
		end
	end

	def update_settings
		@email_settings = EmailSettings.find_by_campaign_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_campaign_id(params[:id])
		@campaign = Campaign.find(params[:id])

		# ensure we have a fqdn to go active
		#if @campaign.active
		#  if @campaign_settings.fqdn = ""
		#    flash[:notice] = "FQDN Cannot be blank when going Active"
		#    redirect_to(:controller => 'campaigns', :action => 'options', :id => params[:id])
		#    return false
		#  end
		#end

		if @campaign.update_attributes(params[:campaign]) and @email_settings.update_attributes(params[:email_settings]) and @campaign_settings.update_attributes(params[:campaign_settings])
			flash[:notice] = "Campaign Updated"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => params[:id])
		else
			@templates = Template.all
			render('options')
		end
	end

	def delete
		@campaign = Campaign.find(params[:id])
	end

	def destroy
		CampaignSettings.find_by_campaign_id(params[:id]).destroy
		EmailSettings.find_by_campaign_id(params[:id]).destroy
		Campaign.find(params[:id]).destroy
		flash[:notice] = "Campaign Destroyed"
		redirect_to(:action => 'list')
	end

	def options
		@email_settings = EmailSettings.find_by_campaign_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_campaign_id(params[:id])
		@templates = Template.all
		@campaign = Campaign.find_by_id(params[:id])
		@victims = Victims.where("campaign_id = ?", params[:id])
		if @campaign.nil?
			flash[:notice] = "Campaign Does not Exist"
			redirect_to(:controller => 'campaigns', :action => 'list')
		end   
	end

	def victims
		@victims = Victims.where("campaign_id = ?", params[:id])
		if @victims.empty?
			flash[:notice] = "Campaign Does not Exist"
			redirect_to(:controller => 'campaigns', :action => 'list')
		end
	end

	def clear_victims
		Victims.where("campaign_id = ?", params[:id]).delete_all
		flash[:notice] = "Victims Cleared"
		redirect_to(:controller => 'campaigns', :action => 'options', :id => params[:id])
	end

	def delete_victim
		victim = Victims.find_by_id(params[:id])
		if victim.nil?
			flash[:notice] = "Victim Does not Exist"
			redirect_to(:controller => 'campaigns', :action => 'list')
		end

		victim.destroy
		flash[:notice] = "Deleted #{victim.email_address}"
		redirect_to(:controller => 'campaigns', :action => 'victims', :id => victim.campaign_id)		
	end
end
