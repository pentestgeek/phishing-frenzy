class StatsSummaryPdf < Prawn::Document

  # create PDF layout and contents
  def initialize(campaign, view)
    super()
    @view = view
    @campaign = campaign

    @victims_responded = Array.new
    @victims_no_action = Array.new

    @campaign.victims.each do |victim|
      if !victim.opened?
        @victims_no_action << victim
      end
    end

    @campaign.victims.each do |victim|
      if victim.opened?
        @victims_responded << victim
      end
    end

    header
    campaign_overview
    stats_summary
    victims_responded if !@victims_responded.empty?
    victims_no_action if !@victims_no_action.empty?
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
    text "Emails Sent: #{@campaign.sent}"
    text "Emails Opened: #{@campaign.opened}"
    text "Emails Clicked: #{@campaign.clicks}"
    text "Success: #{@campaign.success} %"
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

  def victims_responded
    text "Victims Responded", style: :bold
    move_down 10
    table victims_responded_line_items do
      row(0).font_style = :bold # header bold
      self.row_colors = ["DDDDDD", "FFFFFF"] # rotate row colors
      self.header = true
      self.cells.style {|cell| cell.size = 10}
      self.cells.style {|cell| cell.border_width = 0}
    end
    move_down 20
  end

  def victims_no_action
    text "Victims No Action", style: :bold
    move_down 10
    table victims_no_action_line_items do
      row(0).font_style = :bold # header bold
      self.row_colors = ["DDDDDD", "FFFFFF"] # rotate row colors
      self.header = true
      self.cells.style {|cell| cell.size = 10}
      self.cells.style {|cell| cell.border_width = 0}
    end
    move_down 20
  end

  # structure each victim as a line_item
  def victims_no_action_line_items
    @victims = Array.new

    [["UID", "Email", "Sent", "Clicked", "Opened", "Password", "Time"]] +
    @victims_no_action.map do |victim|
      [victim.uid, 
      victim.email_address, 
      victim.sent.to_s, 
      victim.clicked?.to_s, 
      victim.opened?.to_s, 
      victim.password?.to_s, 
      victim.updated_at.to_s ]
    end
  end

  # structure each victim as a line_item
  def victims_responded_line_items
    # campaign.victims.each {|victim| @victims = victim.opened? ? victim : nil}

    [["UID", "Email", "Sent", "Clicked", "Opened", "Password", "Time"]] +
    @victims_responded.map do |victim|
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
