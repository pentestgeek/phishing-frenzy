class PhishingFrenzyMailer < ActionMailer::Base

  def intel(campaign_id, target, active=false)
    @campaign = Campaign.find(campaign_id)
    @display_from = @campaign.email_settings.display_from
    @date = Time.now.to_formatted_s(:long_ordinal)
    track = @campaign.campaign_settings.track_uniq_visitors?
    phishing_url = @campaign.email_settings.phishing_url
    @target = target

    if active
      @url = full_url(@target, phishing_url, track)
      campaign_smtp_settings = {
          address: @campaign.email_settings.smtp_server,
          port: @campaign.email_settings.smtp_port,
          user_name: @campaign.email_settings.smtp_username,
          password: @campaign.email_settings.smtp_password,
          authentication: 'plain',
          enable_starttls_auto: true
      }

      bait = mail(
          to: @target,
          from: @campaign.email_settings.from,
          subject: @campaign.email_settings.subject,
          template_name: @campaign.template.location,
          delivery_method: :smtp
      )
      bait.delivery_method.settings.merge!(campaign_smtp_settings)
      bait
    else
      @url = full_url(@target, phishing_url, track)
      mail(
          to: @target,
          subject: @campaign.email_settings.subject,
          template_name: @campaign.template.location,
          delivery_method: :letter_opener_web)
    end
  end

  private
  def full_url(target, url, track)
    if track
      # append uniq identifier
      encode = "#{Base64.encode64(target)}"
      "#{url}?id=#{encode.chomp}"
    else
      url
    end
  end
end
