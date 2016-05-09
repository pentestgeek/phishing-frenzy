class ReportsController < ApplicationController
  protect_from_forgery except: [ :results, :image ]

  def index
    list
    render('list')
  end

  def list
    @campaigns = Campaign.launched.order(created_at: :desc)
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
      passwordSeen = Credential.joins(:visit).where(visits: { victim_id: victim.id }).count > 0 ? 'Yes' : 'No'
      visits = Visit.where(victim_id: victim.id).order(:created_at)
      imageSeen = visits.empty? ? 'No' : 'Yes'
      emailSent = victim.sent ? 'Yes' : 'No'
      emailClicked =  visits.select{ |v| v.extra.nil? }.count > 0 ? 'Yes' : 'No'
      email_last_seen = visits.count > 0 ? visits.last.created_at : 'N/A'
      jsonToSend["aaData"][i] = [victim.uid,victim.email_address,emailSent,imageSeen,emailClicked,passwordSeen, email_last_seen]
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
    @visits = Visit.includes(:victim, :credential).joins(:victim, :credential).where(victims: { campaign_id: params[:id] })
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

