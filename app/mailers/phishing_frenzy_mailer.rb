class PhishingFrenzyMailer < ActionMailer::Base

  PREVIEW = 0
  ACTIVE = 1

  def phish(campaign_id, target_email, blast_id, method=PREVIEW)
    @campaign = Campaign.find(campaign_id)
    @display_from = @campaign.email_settings.display_from
    @date = Time.now.to_formatted_s(:long_ordinal)
    phishing_url = @campaign.email_settings.phishing_url
    blast = @campaign.blasts.find(blast_id)

    # We use a custom message and content ID to prevent leaking data
    # about our phishing setup
    mid = "<#{Mail.random_tag}@#{@campaign.email_settings.domain}.mail>"

    @campaign.template.images.each do |image|
      attachments.inline[image[:file]] = File.read(image.file.current_path)
      # Only inline attachments have cids:
      # https://github.com/mikel/mail/blob/master/lib/mail/part.rb#L42
      cid = "<#{Mail.random_tag}@#{@campaign.email_settings.domain}>"
      attachments[image[:file]].add_content_id(cid)
    end

    @campaign.template.file_attachments.each do |attachment|
      attachments[File.basename attachment.file.to_s] = {
        content_type: attachment.file.content_type,
        body: File.read(attachment.file.current_path)
      }
    end

    @target = get_victim(target_email, campaign_id)
    uid = @target.uid.to_s

    if @campaign.campaign_settings.track_uniq_visitors?
      @url = "#{phishing_url}?uid=#{uid}"
      @image_url = "#{phishing_url}/reports/image/#{uid}.png"
    else
      @url = phishing_url
      # Don't know a default non-tracking image?
      @image_url = "#{phishing_url}/reports/image/000000.png"
    end

    mail_opts =  {
        message_id: mid,
        to: @target.email_address,
        from: "\ #{@campaign.email_settings.display_from}\ \<#{@campaign.email_settings.from}\>",
        subject: @campaign.email_settings.subject,
        template_path: @campaign.template.email_template_path,
        template_name: @campaign.template.email_files.first[:file]
    }

    mail_opts[:reply_to] = @campaign.email_settings.reply_to unless @campaign.email_settings.reply_to.blank?
    case method
    when ACTIVE
      mail_opts[:delivery_method] = :smtp
      bait = mail(mail_opts) do |format|
        format.html { render file: @campaign.template.email_files.first.file.path }
        # TODO
        # check if template has uploaded a TXT version of email and if so
        # use the format.txt method below as well for higher spam scores
        #
        # format.txt { render file: @campaign.template.email_files.first.file.path }
      end
      # if no authentication is selected send anonymous smtp
      if @campaign.email_settings.authentication == "none"
        bait.delivery_method.settings.merge!(campaign_anonymous_smtp_settings)
      else
        bait.delivery_method.settings.merge!(campaign_smtp_settings)
      end
    when PREVIEW
      mail_opts[:delivery_method] = :letter_opener_web
      bait = mail(mail_opts)
    else
      raise RuntimeError, 'Unknown mailer action'
    end

    sent = cast(blast, bait)
    @target.update_attribute(:sent, true) if sent && (method == ACTIVE)
  end

  def cast(blast, bait)
    sent = false
    # log smtp communication
    response = nil
    error = nil
    begin
      sleep(@campaign.campaign_settings.smtp_delay)
      response = bait.deliver!
      sent = true
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

    sent
  end

  def campaign_smtp_settings
    campaign_anonymous_smtp_settings.merge({
      user_name: @campaign.email_settings.smtp_username,
      password: @campaign.email_settings.smtp_password,
      authentication: @campaign.email_settings.authentication.to_sym,
    })
  end

  def campaign_anonymous_smtp_settings
    {
      openssl_verify_mode: @campaign.email_settings.openssl_verify_mode_class,
      address: @campaign.email_settings.smtp_server_out,
      port: @campaign.email_settings.smtp_port,
      enable_starttls_auto: @campaign.email_settings.enable_starttls_auto,
      return_response: true,
      domain: @campaign.email_settings.domain
    }
  end

  def get_victim(email, campaign_id)
    victim = Victim.find_by(email_address: email, campaign_id: campaign_id)
    victim = Victim.new(email_address: email,
                        uid: '000000',
                        firstname: 'Firstname',
                        lastname: 'Lastname') unless victim

    victim
  end
end
