class EmailController < ApplicationController
	before_filter :confirm_logged_in

	def index
		send_email
		render('send')
	end

	def send_email
		unless prepare_sending
			flash[:notice] = "#{@flash}"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
			return false
		end

		if read_email(@email_settings.emails_sent)
			render('send')
		else
			flash[:notice] = "Read Email method has failed"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
			return false		
		end
	end

	def launch_email
		unless prepare_sending
			flash[:notice] = "#{@flash}"
			redirect_to(:controller => 'campaigns', :action => 'options', :id => @campaign.id)
			return false
		end

		emails_sent = read_email(@email_settings.emails_sent)
		@email_settings.update_attribute(:emails_sent, emails_sent)

		# update email_sent in db
		@campaign.update_attribute(:email_sent, true)
		flash[:notice] = "Campaign Launched"
		render('send')
	end

	def prepare_sending
		@email_settings = EmailSettings.find_by_campaign_id(params[:id])
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_campaign_id(params[:id])
		@victims = Victims.where("campaign_id = ?", params[:id])
		@messages = []

		# make sure we have a campaign
		if @campaign
			@template = Template.find_by_id(@campaign.template_id)
		else
			@flash = "No Campaign Found"
			return false
		end

		# make sure we have victims to send to
		if @victims.empty?
			@flash = "No Victims to Send To"
			return false
		end

		# make sure we have email settings
		unless @email_settings
			@flash = "No Email Settings Found"
			return false
		end

		# ensure smtp settings are populated
		if @email_settings.smtp_server == ""
			@flash = "No SMTP Server to send from"
			return false
		end

		if @email_settings.smtp_server_out == ""
			@flash = "No Outbound SMTP Server to send from"
			return false
		end

		if @email_settings.smtp_port == ""
			@flash = "No SMTP Port specified"
			return false
		end

		# ensure email settings are populated
		if @email_settings.from == ""
			@flash = "No From address specified"
			return false
		end

		return true
	end

	def sendemail(username, password, from, message, email, port, smtpout, smtp)
		begin
			Timeout.timeout(5){
				Net::SMTP.start("#{smtpout}", "#{port}", "#{smtp}","#{username}", "#{password}", :plain) do |smtp|
					smtp.send_message message, "#{from}", email.chomp
				end
				@messages << "[+] Successfully sent to: #{email}"
				return true
			}
		rescue => e
			@messages << "[-] #{e} when sending to #{email} through #{smtp}:#{port}"
			return false
		rescue Timeout::Error
			@messages << "[-] SMTP Timeout Sending to #{email} using #{smtp}:#{port}\n"	
			return false
		end
	end

	def sendemail_encrypted(username, password, message, email, smtp_address, port)
		begin
			Timeout.timeout(5){
				smtp = Net::SMTP.new(smtp_address, port)
				smtp.enable_starttls
				smtp.start(smtp, username, password, :login) do
					smtp.send_message(message, username, email)
				end
				@messages << "[+] Successfully sent to: #{email}"
				return true
			}
		rescue => e 
			@messages << "[-] #{e} when sending to #{email} using SSL through #{smtp_address}:#{port}"
			return false
		rescue Timeout::Error
			@messages << "[-] SMTP Timeout Sending to #{email} using #{smtp_address}:#{port} with SSL\n"		
			return false
		end
	end

	def read_email(emails_sent = 0)
		@victims.each do |victim|
			message = []

			# make sure email exists
			email_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", "email.txt")
			if File.exist?(email_location)
				email_message = File.open(email_location, 'r')
			else
				@messages << "[-] Unable to Read #{email_location}"
			end

			# track user clicks?
			if @campaign_settings.track_uniq_visitors?
				# append uniq identifier
				encode = "#{Base64.encode64(victim.email_address)}"
				full_url = "#{@email_settings.phishing_url}?id=#{encode.chomp}"
			else
				full_url = "#{@email_settings.phishing_url}"	
			end

			# prepare email message
			email_message.each_line do |line|
				if line =~ /\#{url}/
					message << line.gsub(/\#{url}/, "#{full_url}")
				elsif line =~ /\#{to}/
					message << line.gsub(/\#{to}/, "#{victim.email_address}")
				elsif line =~ /\#{from}/ and line =~ /\#{display_from}/
					message << line.gsub(/\#{display_from} <\#{from}>/, "#{@email_settings.display_from} <#{@email_settings.from}>")
				elsif line =~ /\#{display_from}/ and not line =~ /\#{from}/
					message << line.gsub(/\#{display_from}/, "#{@email_settings.display_from}")
				elsif line =~ /\#{subject}/
					message << line.gsub(/\#{subject}/, "#{@email_settings.subject}")
				elsif line =~ /\#{date}/
					message << line.gsub(/\#{date}/, Time.now.to_formatted_s(:long_ordinal))
				else
					message << line
				end
			end		
			email_message.close

			# if encrypted email fails, sent cleartext email
			ssl = true
			if ssl
				if sendemail_encrypted(@email_settings.smtp_username, @email_settings.smtp_password, message, victim.email_address, @email_settings.smtp_server, @email_settings.smtp_port)
					emails_sent += 1
					next
				else
					ssl = false
					if sendemail(@email_settings.smtp_username, @email_settings.smtp_password, @email_settings.from, message, victim.email_address, @email_settings.smtp_port, @email_settings.smtp_server_out, @email_settings.smtp_server)	
						emails_sent += 1
					else
						@messages << "[-] Unable to send #{victim.email_address}"
					end
				end
			else
				if sendemail(@email_settings.smtp_username, @email_settings.smtp_password, @email_settings.from, message, victim.email_address, @email_settings.smtp_port, @email_settings.smtp_server_out, @email_settings.smtp_server)	
					emails_sent += 1
				end
			end

		end
		return emails_sent
	end
end
