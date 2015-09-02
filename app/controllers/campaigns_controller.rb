class CampaignsController < ApplicationController
  skip_before_filter :authenticate_admin!, only: [ :view_campaign ]

	include ActionView::Helpers::JavaScriptHelper # to be able to use escape_javascript
	
	def index
		list
		render('list')
	end

	def list
		# grab the campaigns and sort by created_at date
		@campaigns = Campaign.includes(:victims, :admin).order("created_at DESC")
	end

	def home
		@activities = PublicActivity::Activity.includes(:trackable, :owner).order('created_at DESC').limit(30)
		@campaigns = Campaign.launched.order("created_at DESC").limit(10)
	end

	def show
		@templates = Template.all
		@campaign = Campaign.includes(:campaign_settings, :email_settings).find(params[:id])
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
		@campaign.admin_id = current_admin.id

		if @campaign.save 
			redirect_to @campaign, notice: "Campaign Created"
		else
			render('new')
		end
	end

	def edit
		@campaign = Campaign.find(params[:id])
	end

	def update
		@campaign = Campaign.find(params[:id])
		if params[:campaign][:email_settings_attributes][:smtp_password].blank? && !@campaign.email_settings.smtp_password.blank?
			params[:campaign][:email_settings_attributes][:smtp_password] = @campaign.email_settings.smtp_password
		end
		if @campaign.update_attributes(params[:campaign])
			redirect_to @campaign, notice: "Campaign Updated"
		else
			@templates = Template.all
			render('show')
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

	def activity
		@activities = PublicActivity::Activity.includes(:trackable, :owner).order('created_at DESC').page(params[:page]).per(30)
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

  def view_campaign
    @campaign = Campaign.find(params[:id])

    # Allow uid 000000 for testing the campaign
    if params[:uid] == '000000'
      v = Victim.new
    else
      # Should this be constrianed to the campaign
      v = @campaign.victims.find_by(uid: params[:uid])
    end

    if v
      visit = Visit.new
      visit.victim_id = v.id
      visit.ip_address = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
      visit.browser = request.env['HTTP_USER_AGENT']
      visit.extra = params[:extra] if params[:extra]
      visit.save
    else
      Rails.logger.info "Unknown UID: #{params[:uid].inspect} - #{params[:filename].inspect}"
      # If someone is browsing to the root site, or the index page, give
      # them a 404 if we don't know who they are... We need to carry on
      # for other assets etc that may be required/included in the
      # page.
      if !params[:filename] || params[:filename].downcase.include?('index')
        raise ActiveRecord::RecordNotFound
      end
    end

    # TODO: If they have a valid UID but browsing to the root then display the
    # index page.
    if v && (!params.has_key?(:filename) || params[:filename].blank?)
      unless params[:uid]
        raise ActiveRecord::RecordNotFound
      end
      render text: "render default index file!"
      return
    end

    # Otherwise serve up the website file...
    @campaign.template.website_files.each do |attachment|
      if attachment.file_identifier.downcase == params[:filename].downcase
        begin
          f = File.read(attachment.file.current_path)
          content_type = attachment.file.content_type
          if content_type.include?('http')
            render text: f
          else
            send_data f, type: content_type, disposition: 'inline'
          end
        rescue Exception => e
          render text: "500 Server Error", status: 500
          Rails.logger.error e
        ensure
          return
        end
      end
    end

    raise ActiveRecord::RecordNotFound
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
