require 'net/http'

class ReportsController < ApplicationController
  skip_before_filter :authenticate_admin!, only: [ :results, :image ]
  protect_from_forgery except: [ :results, :image ]

  def index
    list
    render('list')
  end

  def list
    @campaigns = Campaign.launched.order(created_at: :desc)
  end

  def image
    victims = Victim.where(:uid => params[:uid])
    unless victims.present?
      render text: "No UID Found"
      return
    end

    visit = Visit.new
    victim = victims.first
    visit.victim_id = victim.id
    visit.browser = request.env["HTTP_USER_AGENT"]
    visit.ip_address = request.env["REMOTE_ADDR"]
    visit.extra = "SOURCE: EMAIL"
    visit.save
    send_file File.join(Rails.root.to_s, "public", "tracking_pixel.png"), :type => 'image/png', :disposition => 'inline'
  end

  def stats
    @campaign = Campaign.find_by_id(params[:id])
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = StatsSummaryPdf.new(@campaign, view_context)
        send_data pdf.render, filename: "phishing-frenzy-stats.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def results
    finish = "start, "
    if params[:uid]
      finish += "uid check, "
      victims = Victim.where(:uid => params[:uid])
      finish += "length " + victims.length.to_s + ", "
      if victims.length > 0
        finish += "over 1, "
        v = victims.first()
        visit = Visit.new()
        visit.victim_id = v.id
        if params[:browser_info]
          finish += "browser info, "
          visit.browser = params[:browser_info]
        end
        if params[:ip_address]
          finish += "ip address, "
          visit.ip_address = params[:ip_address]
        end
        if params[:extra]
          finish += "extra, "
          visit.extra = params[:extra]
        end
        visit.save()
      end
    end

    render text: finish
  end

  def stats_sum
    # Campaign for the reports
    @campaign = Campaign.includes(:victims).find(params[:id])

    # Time since campaign was started.
    t = (Time.now - @campaign.created_at)
    @time = "%sD - %sH - %sM - %sS" % [(((t/60)/60)/24).floor, ((((t)/60)/60)% 24).floor, ((t / 60) % 60).floor, (t % 60).floor]

    # Total number of emails sent.
    @emails_sent =  @campaign.victims.where(sent: true).size

    # Total visits to the website.
    @visits = @campaign.clicks
    @opened = @campaign.opened

    @jsonToSend = Hash.new()
    @jsonToSend["campaign_name"] = @campaign.name
    @jsonToSend["time"] = @time
    @jsonToSend["active"] = @campaign.active
    @jsonToSend["template"] = @campaign.template.name if @campaign.template
    @jsonToSend["sent"] = @emails_sent
    @jsonToSend["opened"] = @opened
    @jsonToSend["clicked"] = @visits

    render json: @jsonToSend
  end

  def victims_list 
    jsonToSend = Hash.new()
    jsonToSend["aaData"] = Array.new(Victim.where(campaign_id: params[:id]).count)
    i = 0
    Victim.where(campaign_id: params[:id]).each do |victim|
      passwordSeen = Visit.where(:victim_id => victim.id).where('extra LIKE ?', "%password%").count > 0 ? "Yes" : "No"
      imageSeen = Visit.where(:victim_id => victim.id).count > 0 ? "Yes" : "No"
      emailSent = victim.sent ? "Yes" : "No"
      emailClicked =  Visit.where(:victim_id => victim.id).where(:extra => nil).count + Visit.where(:victim_id => victim.id).where('extra not LIKE ?', "%EMAIL%").count > 0 ? "Yes" : "No"
      emailSeen = Visit.where(:victim_id => victim.id).last() != nil ? Visit.where(:victim_id => victim.id).last().created_at : "N/A"
      jsonToSend["aaData"][i] = [victim.uid,victim.email_address,emailSent,imageSeen,emailClicked,passwordSeen,emailSeen]
      i += 1
    end

    render json: jsonToSend
  end

  # call BeEF's RESTful API to retrieve online/offline hooked browsers, storing in the PF DB details and updating the Victims tables too.
  def synch_with_beef(campaign_id)
    campaign_id = campaign_id.to_i
    campaign_settings = CampaignSettings.where(:campaign_id => campaign_id).first
    beef_uri = URI.parse(campaign_settings.beef_url)
    beef_server = "#{beef_uri.scheme}://#{beef_uri.host}:#{beef_uri.port}"

    begin
      online = Net::HTTP.get(URI.parse("#{beef_server}/api/hooks/pf/online?token=#{campaign_settings.beef_apikey}"))
      offline = Net::HTTP.get(URI.parse("#{beef_server}/api/hooks/pf/offline?token=#{campaign_settings.beef_apikey}"))

      JSON.parse(online)['aaData'].each do |hb|
        store_hooked_browsers campaign_id, hb
      end

      JSON.parse(offline)['aaData'].each do |hb|
        store_hooked_browsers campaign_id, hb
      end
    rescue => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      flash[:error] = "ERROR: cannot synch with BeEF. Check if BeEF is enabled and running with correct settings."
    end

  end

  def store_hooked_browsers(campaign_id, hb)
    victim_uid = hb[2]

    if HookedBrowsers.where(hb_id: hb[0]).empty?
      victim = Victim.where(campaign_id: campaign_id).where(uid: victim_uid)
      if victim != nil && victim.first != nil
        hooked_browser = HookedBrowsers.create(
            hb_id: hb[0],
            ip: hb[1],
            victim_id: victim.first.id,
            btype: hb[3],
            bversion: hb[4],
            os: hb[5],
            platform: hb[6],
            language: hb[7],
            plugins: hb[8],
            city: hb[9],
            country: hb[10]
        )

        # update Victim table with HookedBrowser relation
        victim.first.hb_id = hooked_browser.id
        victim.first.save
      end
    end
  end

  def uid
    @victim = Victim.find_by_uid(params[:id])
  end

  def uid_json
    jsonToSend = Hash.new()
    jsonToSend["aaData"] = Array.new(Visit.where(victim_id: Victim.where(uid: params[:id]).first.id))
    i = 0
    Visit.where(victim_id: Victim.where(uid: params[:id]).first.id).each do |visit|
      jsonToSend["aaData"][i] = [visit.id,visit.browser,visit.ip_address,visit.created_at,visit.extra]
      i += 1
    end

    render json: jsonToSend
  end

  def download_stats
    # download all campaign details to xml
    @campaign = Campaign.find_by_id(params[:id])
    respond_to do |format|
      format.xml { render :xml => @campaign.to_xml(include: [:baits, victims: {include: :visits}]) }
    end
  end

  def download_logs
    # download the apache logs for campaign
    @campaign = Campaign.find_by_id(params[:id])
    logfile_name = Campaign.logfile(@campaign)
    begin
      # push file to browser for download
      send_file logfile_name, :type => 'application/zip', :disposition => 'attachment', :filename => Pathname.new(logfile_name).basename
    rescue => e
      redirect_to :back, notice: "Download Error: #{e}"
    end
  end

  def download_excel
    @campaign = Campaign.find(params[:id])
    @victims = @campaign.victims

    # synch the PF db with BeEF data
    if @campaign.campaign_settings.use_beef?
      synch_with_beef params[:id]
    end

    package = Axlsx::Package.new
    wb = package.workbook
    wb.styles do |s|
      @heading = s.add_style alignment: {horizontal: :center}, b: true, bg_color: "ca0002", fg_color: "FF", border: {style: :thin, color: "00000000"}
      @data = s.add_style alignment: {wrap_text: true, horizontal: :left, vertical: :top}, height: 14, border: {style: :thin, color: "00000000"}
    end

    wb.add_worksheet(name: "Targets") do |sheet|
      sheet.add_row [
        "Target",
        "Clicked?",
        "Opened?",
        "IP",
        "Location",
        "Browser",
        "Operating System",
        "Language",
        "Plugins"], style: @heading
      @victims.each do |victim|

        @hooked_browser = HookedBrowsers.where(:victim_id => victim.id).first

        if @hooked_browser == nil
          sheet.add_row [
             victim.email_address,
             victim.clicked?,
             victim.opened?, "","","","","",""], style: @data
        else
          sheet.add_row [
             victim.email_address,
             victim.clicked?,
             victim.opened?,
             @hooked_browser.ip,
             "#{@hooked_browser.city} - #{@hooked_browser.country}",
             "#{@hooked_browser.btype}-#{@hooked_browser.bversion}",
             "#{@hooked_browser.os} (#{@hooked_browser.platform})",
             @hooked_browser.language,
             @hooked_browser.plugins], style: @data
        end
      end
      sheet.column_widths 30, 8, 8, 10, 15, 6, 15, 8, 70
    end

    send_data package.to_stream.read, 
      :filename => "#{@campaign.name}-#{@campaign.id}".parameterize + ".xlsx", 
      :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
  end

  def apache_logs
    # display all apache logs for campaign
    @campaign = Campaign.find(params[:id])
    begin
      @logs = File.read(Campaign.logfile(@campaign))
    rescue => e
      redirect_to :back, notice: "Error: #{e}"
    end
  end

  def hooked_browsers
    # retrieve from the db BeEF related settings to be used when calling the RESTful API
    campaign_settings = CampaignSettings.where(:campaign_id => params[:id]).first
    beef_uri = URI.parse(campaign_settings.beef_url)
    @beef_server = "#{beef_uri.scheme}://#{beef_uri.host}:#{beef_uri.port}"
    @beef_apikey = campaign_settings.beef_apikey
    @campaign = Campaign.find(params[:id])

    # synch the PF db with BeEF data
    synch_with_beef params[:id]

    victims = Hash.new
    Victim.where(campaign_id: params[:id]).each do |victim|
        if victim.clicked?
          victims[victim.uid] = victim.email_address
        end
    end
    @victims_clickonly = victims.to_json
  end

  def passwords
    # display all password harvested within campaign
    @campaign = Campaign.find(params[:id])
    @visits = @campaign.visits.where('extra LIKE ?', "%password%")
  end

  def smtp
    # display all smtp logs for campaign
    @campaign = Campaign.find(params[:id])
  end

  def clear
    # clear campaign statistics
    campaign = Campaign.find(params[:id])
    campaign.victims.destroy_all
    redirect_to :back, notice: "Cleared Campaign Stats and removed Victims"
  end

end

