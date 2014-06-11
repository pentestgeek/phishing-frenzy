class StatsSummaryPdf < Prawn::Document

  # create PDF layout and contents
  def initialize(campaign, view)
    super()
    @view = view
    @campaign = campaign
    header
    campaign_overview
    stats_summary
    victims_summary
  end

  # add header to PDF
  def header
    text "Phishing Frenzy Results", size: 30, style: :bold
    move_down 20
  end

  # display overview
  def campaign_overview
    text "Campaign Overview", style: :bold
    text "ID: #{@campaign.id}"
    text "Name: #{@campaign.name}"
    move_down 20
  end

  # display summary stats
  def stats_summary
    text "Campaign Summary", style: :bold
    text "Emails Sent: #{Campaign.sent(@campaign)}"
    text "Emails Opened: #{Campaign.opened(@campaign)}"
    text "Emails Clicked: #{Campaign.clicks(@campaign)}"
    text "Success: #{Campaign.success(@campaign)} %"
    move_down 20
  end

  # display victim details
  def victims_summary
    text "Targets Summary", style: :bold
    move_down 10
    table victims_line_items do
      row(0).font_style = :bold # header bold
      self.row_colors = ["DDDDDD", "FFFFFF"] # rotate row colors
      self.header = true
      self.cells.style {|cell| cell.size = 10}
      self.cells.style {|cell| cell.border_width = 0}
    end
  end

  # structure each victim as a line_item
  def victims_line_items
    [["UID", "Email", "Sent", "Clicked", "Opened", "Password", "Time"]] +
    @campaign.victims.map do |victim|
      [victim.uid, 
      victim.email_address, 
      victim.sent.to_s, 
      victim.clicked?.to_s, 
      victim.opened?.to_s, 
      victim.password?.to_s, 
      victim.updated_at.to_s ]
    end
  end
end