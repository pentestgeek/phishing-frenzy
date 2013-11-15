class CampaignsController < ApplicationController
	include ActionView::Helpers::JavaScriptHelper # to be able to use escape_javascript
	before_filter :confirm_logged_in
	
	def index
		list
		render('list')
	end

	def list
		# grab the campaigns and sort by id
		@campaigns = Campaign.order("id").page(params[:page]).per(8)
	end

	def home
		# grab only the active campaigns
		@campaigns = Campaign.active.page(params[:page]).per(8)

		# determine if apache is running
		apache_output = GlobalSettings.apache_status
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
		@campaign = Campaign.find_by_id(params[:id], :include => [:campaign_settings, :email_settings])

		# ensure we have required dependencies to go active
		if params[:campaign][:active] == "1"
			if params[:campaign_settings][:fqdn] == ""
				flash[:notice] = "FQDN cannot be blank when active"
				redirect_to(:controller => 'campaigns', :action => 'options', :id => params[:id])
				return false
			end
		end

		if @campaign.update_attributes(params[:campaign]) and @campaign.email_settings.update_attributes(params[:email_settings]) and @campaign.campaign_settings.update_attributes(params[:campaign_settings])
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
		Campaign.find(params[:id]).destroy
		flash[:notice] = "Campaign Destroyed"
		redirect_to(:action => 'list')
	end

	def options
		@templates = Template.all
		@campaign = Campaign.find_by_id(params[:id], :include => [:campaign_settings, :email_settings])
		@victims = Victim.where("campaign_id = ?", params[:id])
		if @campaign.nil?
			flash[:notice] = "Campaign Does not Exist"
			redirect_to(:controller => 'campaigns', :action => 'list')
		end   
	end

	def victims
		@victims = Victim.where("campaign_id = ?", params[:id])
		if @victims.empty?
			flash[:notice] = "Campaign Does not Exist"
			redirect_to(:controller => 'campaigns', :action => 'list')
		end
	end

	def clear_victims
		Victim.where("campaign_id = ?", params[:id]).delete_all
		flash[:notice] = "Victims Cleared"
		redirect_to(:controller => 'campaigns', :action => 'options', :id => params[:id])
	end

	def delete_victim
	victim = Victim.find_by_id(params[:id])
	if victim.nil?
		flash[:notice] = "Victim Does not Exist"
		redirect_to(:controller => 'campaigns', :action => 'list')
	end

	victim_id_to_destroy = victim.id

	victim.destroy
	flash[:notice] = "Deleted #{victim.email_address}"
	respond_to do |format|
		format.html { redirect_to(:controller => 'campaigns', :action => 'victims', :id => victim.campaign_id) }
		# This is kinda hacky, but works until we figure out the 'rails' way
		format.js { render :text => "$('#victim-#{victim_id_to_destroy}').remove();
									if (!$('.notice').length > 0) { $('div #content').prepend('<div class=\"notice\"></div>'); }
									$('.notice').html(\"#{escape_javascript(flash[:notice])}\");
									$('.notice').show(300);" }
		end
	end

	def smtp
		@campaign = Campaign.find_by_id(params[:id])
	end

	def delete_smtp_entry
		smtp = SmtpCommunication.find_by_id(params[:id])
		campaign_id = smtp[:campaign_id]
		SmtpCommunication.find_by_id(params[:id]).destroy
		flash[:notice] = "SMTP Entry Deleted"
		redirect_to(:controller => 'campaigns', :action => 'smtp', :id => campaign_id)	
	end
end
