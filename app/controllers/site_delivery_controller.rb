class SiteDeliveryController < ApplicationController
  skip_before_filter :authenticate_admin!

  def view
    @campaign = Campaign.find(params[:id])

    # Allow uid 000000 for testing the campaign
    if params[:uid] == '000000'
      v = Victim.new
    else
      v = @campaign.victims.find_by(uid: params[:uid])
    end

    if v
      visit = Visit.new
      visit.victim_id = v.id
      visit.ip_address = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
      visit.browser = request.env['HTTP_USER_AGENT']
      visit.extra = params[:extra] if params[:extra]
      visit.save unless v.id == '000000'
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
      render text: "TODO: render default index file!"
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

end
