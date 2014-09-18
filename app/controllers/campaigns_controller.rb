class CampaignsController < ApplicationController

	include ActionView::Helpers::JavaScriptHelper # to be able to use escape_javascript
	
	def index
		list
		render('list')
	end

	def list
		# grab the campaigns and sort by created_at date
		@campaigns = Campaign.order("created_at DESC")
	end

	def home
		# grab only the launched campaigns
		@campaigns = Campaign.launched.page(params[:page]).per(16).reverse
	end

	def show
		@templates = Template.all
		@campaign = Campaign.find_by_id(params[:id], :include => [:campaign_settings, :email_settings])
		@blasts = @campaign.blasts.order('created_at DESC').limit(10)
		@victims = Victim.where("campaign_id = ? and archive = ?", params[:id], false)
		@template = @campaign.template
		unless @template
			flash.now[:warning] = "No template has been selected for this campaign"
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
				redirect_to @campaign
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
		# ensure we have write access to sites-enabled
		unless File.writable?(GlobalSettings.first.sites_enabled_path)
			redirect_to campaign_path, notice: "File Permission Issue: chmod #{GlobalSettings.first.sites_enabled_path}"
			return
		end

		@campaign = Campaign.find(params[:id])
		if @campaign.update_attributes(params[:campaign])
			flash[:notice] = "Campaign Updated"
			redirect_to @campaign
		else
			render('edit')
		end
	end

	def update_settings
		# ensure we have write access to sites-enabled
		unless File.writable?(GlobalSettings.first.sites_enabled_path)
			redirect_to campaign_path, notice: "File Permission Issue: chmod #{GlobalSettings.first.sites_enabled_path}"
			return
		end
	
		@campaign = Campaign.find_by_id(params[:id], :include => [:campaign_settings, :email_settings])

		# ensure we have required dependencies to go active
		if params[:campaign][:active] == "1"
			if params[:campaign_settings][:fqdn] == ""
				redirect_to campaign_path(params[:id]), notice: "FQDN cannot be blank when active"
				return false
			end
		end

		if @campaign.update_attributes(params[:campaign]) and @campaign.email_settings.update_attributes(params[:email_settings]) and @campaign.campaign_settings.update_attributes(params[:campaign_settings])
			flash[:notice] = "Campaign Updated"
			redirect_to @campaign
		else
			@templates = Template.all
			render('form')
		end
	end

	def delete
		@campaign = Campaign.find(params[:id])
	end

	def destroy
		Campaign.find(params[:id]).destroy
		flash[:notice] = "Campaign Destroyed"
		redirect_to list_campaigns_path
	end

	def options
		@templates = Template.all
		@campaign = Campaign.find_by_id(params[:id], :include => [:campaign_settings, :email_settings])
		@victims = Victim.where("campaign_id = ? and archive = ?", params[:id], false)
		@template = @campaign.template
		unless @template
			flash.now[:warning] = "No template has been selected for this campaign"
		end
		if @campaign.nil?
			flash[:notice] = "Campaign Does not Exist"
			redirect_to(:controller => 'campaigns', :action => 'list')
		end
	end

	def victims
		@victims = Victim.where("campaign_id = ? and archive = ?", params[:id], false)
	end

	def clear_victims
		Victim.where("campaign_id = ? and sent = ?", params[:id], false).delete_all
		archives = Victim.where("campaign_id = ? and sent = ?", params[:id], true)
		archives.each do |victim|
			victim.update_attribute(:archive, true)
		end
		flash[:notice] = "Victims Cleared"
		redirect_to campaign_path(id: params[:id])
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
			format.js
		end
	end
end
