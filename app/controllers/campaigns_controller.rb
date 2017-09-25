class CampaignsController < ApplicationController
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
    @campaigns = Campaign.includes(:victims, :visits).launched.order("created_at DESC").limit(10)
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

  def delete_victim
    victim = Victim.find(params[:id])
    victim.sent ? victim.update_attribute(:archive, true) : victim.destroy!
    flash[:notice] = "Deleted #{victim.email_address}"
    respond_to do |format|
      format.html { redirect_to victims_campaigns_path(id: victim.campaign_id) }
      format.js
    end
  end

  # POST /campaign/:id/reload
  def reload
    campaign = Campaign.find(params[:id])
    if campaign.active?
      campaign.reload
      redirect_to campaign, notice: 'Campaign template successfully reloaded'
    else
      # campaign not active, lets warn user campaign must
      # first be active to reload a template.
      redirect_to campaign, warning: 'Campaign is not active, must be active to reload a template'
    end
  end
end
