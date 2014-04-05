class PhishingFrenzyMailer < ActionMailer::Base
  PREVIEW = 0
  ACTIVE = 1

  def phish(campaign_id, target, blast_id, method=PREVIEW)
    @campaign = Campaign.find(campaign_id)
    @display_from = @campaign.email_settings.display_from
    @date = Time.now.to_formatted_s(:long_ordinal)
    track = @campaign.campaign_settings.track_uniq_visitors?
    phishing_url = @campaign.email_settings.phishing_url
    @target = target
    blast = @campaign.blasts.find(blast_id)

    @campaign.template.images.each do |image|
      attachments.inline[image[:file]] = File.read(image.file.current_path)
    end

    if method==ACTIVE
      @url = full_url(@target, phishing_url, track)
      bait = mail(
          to: @target,
          from: @campaign.email_settings.from,
          subject: @campaign.email_settings.subject,
          template_path: @campaign.template.email_template_path,
          template_name: @campaign.template.email_files.first[:file],
          delivery_method: :smtp
      )
      bait.delivery_method.settings.merge!(campaign_smtp_settings)
      cast(blast, bait)
    else
      @url = full_url(@target, phishing_url, track)
      bait = mail(
          to: @target,
          subject: @campaign.email_settings.subject,
          template_path: @campaign.template.email_template_path,
          template_name: @campaign.template.email_files.first[:file],
          delivery_method: :letter_opener_web)
      cast(blast, bait)
    end
  end

  #private
  def full_url(target, url, track)
    if track
      # append uniq identifier
      encode = "#{Base64.encode64(target)}"
      "#{url}?id=#{encode.chomp}"
    else
      url
    end
  end

  def cast(blast, bait)
    # log smtp communication
    response= nil
    error = nil
    begin
      response = bait.deliver!
    rescue => e
      error = e
    end
    smtp = blast.baits.new(to: bait.to.to_s, from: bait.from.to_s)

    if response.class == Net::SMTP::Response
      smtp.status = response.status
      smtp.message = response.string
    else
      smtp.status = ""
      smtp.message = error.message if error
    end

    # commit changes
    smtp.save
  end

  def campaign_smtp_settings
    {
      :openssl_verify_mode => @campaign.email_settings.openssl_verify_mode_class,
      address: @campaign.email_settings.smtp_server_out,
      port: @campaign.email_settings.smtp_port,
      user_name: @campaign.email_settings.smtp_username,
      password: @campaign.email_settings.smtp_password,
      authentication: @campaign.email_settings.authentication.to_sym,
      enable_starttls_auto: @campaign.email_settings.enable_starttls_auto,
      return_response: true
    }
  end
end