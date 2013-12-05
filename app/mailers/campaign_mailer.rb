class CampaignMailer
	attr_reader :messages, :emails_sent

	def initialize(campaign)
		@campaign = campaign
		@victims = campaign ? @campaign.victims : []
		@emails_sent = 0
	end

	def victims_valid?
		# make sure we have victims to send to
		if @victims.empty?
			@messages << "No Victims to Send To"
			return false
		end

		return true
	end

	def test_victim_valid?
		# make sure we have test victim to send to
		if @campaign.test_victim.email_address.empty?
			@messages << "No Test Victim to Send To"
			return false
		end
	end

	def valid?
		@messages = []

		# make sure we have a campaign
		if @campaign
			@template = Template.find_by_id(@campaign.template_id)
		else
			@messages << "[-] No Campaign Found"
			return false
		end

		# make sure we have email settings
		unless @campaign.email_settings
			@messages << "[-] No Email Settings Found"
			return false
		end

		# ensure smtp settings are populated
		if @campaign.email_settings.smtp_server == ""
			@messages << "[-] No SMTP Server to send from"
			return false
		end

		if @campaign.email_settings.smtp_server_out == ""
			@messages << "[-] No Outbound SMTP Server to send from"
			return false
		end

		if @campaign.email_settings.smtp_port == ""
			@messages << "[-] No SMTP Port specified"
			return false
		end

		# ensure email settings are populated
		if @campaign.email_settings.from == ""
			@messages << "[-] No From address specified"
			return false
		end

		return true
	end

	def test!
		message = read(@campaign.test_victim)
		deliver(@campaign.test_victim, message)
	end

	def launch!
		# if this is the first time launching, clear apache logs for fresh start
		#if @campaign.email_settings.emails_sent == 0
		#	ReportsController.clear_apache_logs(@campaign)
		#end

		@victims.each do |victim|
			message = read(victim)
			deliver(victim, message)
		end

		previously_sent_emails = @campaign.email_settings.emails_sent

		# update emails_sent and email_sent in db
		@campaign.email_settings.update_attribute(:emails_sent, previously_sent_emails + @emails_sent)
		@campaign.update_attribute(:email_sent, true)
	end

	def read(victim)
		@ssl = true
		message = []

		# make sure email exists
		email_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", "email.txt")
		if File.exist?(email_location)
			email_message = File.open(email_location, 'r')
		else
			@messages << "[-] Unable to Read #{email_location}"
		end

		# track user clicks?
		if @campaign.campaign_settings.track_uniq_visitors?
			# append uniq identifier
			encode = "#{Base64.encode64(victim.email_address)}"
			full_url = "#{@campaign.email_settings.phishing_url}?id=#{encode.chomp}"
		else
			full_url = "#{@campaign.email_settings.phishing_url}"
		end

		# prepare email message
		email_message.each_line do |line|
			if line =~ /\#{url}/
				message << line.gsub(/\#{url}/, "#{full_url}")
			elsif line =~ /\#{to}/
				message << line.gsub(/\#{to}/, "#{victim.email_address}")
			elsif line =~ /\#{from}/ and line =~ /\#{display_from}/
				message << line.gsub(/\#{display_from} <\#{from}>/, "#{@campaign.email_settings.display_from} <#{@campaign.email_settings.from}>")
			elsif line =~ /\#{display_from}/ and not line =~ /\#{from}/
				message << line.gsub(/\#{display_from}/, "#{@campaign.email_settings.display_from}")
			elsif line =~ /\#{subject}/
				message << line.gsub(/\#{subject}/, "#{@campaign.email_settings.subject}")
			elsif line =~ /\#{date}/
				message << line.gsub(/\#{date}/, Time.now.to_formatted_s(:long_ordinal))
			else
				message << line
			end
		end
		email_message.close
		message
	end

	def deliver(victim, message)
		# if encrypted email fails, sent cleartext email
		if @ssl
			if sendemail_encrypted(@campaign.email_settings.smtp_username, @campaign.email_settings.smtp_password, @campaign.email_settings.from, message, victim.email_address, @campaign.email_settings.smtp_server, @campaign.email_settings.smtp_port)
				@ssl = true
				@emails_sent += 1
			else
				@ssl = false
				if sendemail(@campaign.email_settings.smtp_username, @campaign.email_settings.smtp_password, @campaign.email_settings.from, message, victim.email_address, @campaign.email_settings.smtp_port, @campaign.email_settings.smtp_server_out, @campaign.email_settings.smtp_server)
					@emails_sent += 1
				else
					@messages << "[-] Unable to send #{victim.email_address}"
				end
			end
		else
			if sendemail(@campaign.email_settings.smtp_username, @campaign.email_settings.smtp_password, @campaign.email_settings.from, message, victim.email_address, @campaign.email_settings.smtp_port, @campaign.email_settings.smtp_server_out, @campaign.email_settings.smtp_server)
				@emails_sent += 1
			end
		end
	end

	def sendemail(username, password, from, message, email, port, smtpout, smtp)
		response = nil
		e = nil
		array = []
		array << smtpout << port << smtp << username << password << :plain
		array = [smtpout] if username.to_s.empty?

		begin
			Timeout.timeout(GlobalSettings.first.smtp_timeout) {
				Net::SMTP.start(*array) do |smtp|
					response = smtp.send_message message, from, email.chomp
				end
				@messages << "[+] Successfully sent to: #{email}"
				return true
			}
		rescue Timeout::Error => e
			@messages << "[-] SMTP Timeout Sending to #{email} using #{smtp}:#{port}\n"
			return false
		rescue Net::SMTPAuthenticationError => e
			@messages << "[-] Invalid Username and or Password"
			return false
		rescue => e
			@messages << "[-] #{e} when sending to #{email} through #{smtp}:#{port}"
			return false
		ensure
			log_smtp_communication(response, email, from, e)
		end
	end

	def sendemail_encrypted(username, password, from, message, email, smtp_address, port)
		response = nil
		e = nil

		begin
			Timeout.timeout(GlobalSettings.first.smtp_timeout) {
				smtp = Net::SMTP.new(smtp_address, port)
				smtp.enable_starttls

				array = []
				array << smtp << username << password
				array = [smtp_address] if username.to_s.empty?

				smtp.start(*array, :login) do
					response = smtp.send_message(message, username, email)
				end
				@messages << "[+] Successfully sent to: #{email}"
				return true
			}
		rescue Timeout::Error => e
			@messages << "[-] SMTP Timeout Sending to #{email} using #{smtp_address}:#{port} with SSL\n"
			return false
		rescue Net::SMTPAuthenticationError => e
			@messages << "[-] Invalid Username and or Password"
			return false
		rescue => e
			@messages << "[-] #{e} when sending to #{email} using SSL through #{smtp_address}:#{port}"
			return false
		ensure
			log_smtp_communication(response, email, from, e)
		end
	end

	def log_smtp_communication(response, to, from, error=nil)
		# log smtp communication
		smtp = SmtpCommunication.new
		smtp.to = to
		smtp.from = from

		if response
			smtp.status = response.status
			smtp.string = response.string
		else
			smtp.status = ""
			smtp.string = error.message if error
		end

		# commit changes
		@campaign.smtp_communications << smtp
	end
end