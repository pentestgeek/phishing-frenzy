class ReportsController < ApplicationController
  skip_before_filter :authenticate_admin!, only: [ :results, :image ]

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
        "Opened?"], style: @heading
      @victims.each do |victim|
        sheet.add_row [
          victim.email_address, 
          victim.clicked?, 
          victim.opened?], style: @data
      end
      sheet.column_widths 50, 20, 20
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

