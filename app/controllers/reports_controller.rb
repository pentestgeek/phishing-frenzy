class ReportsController < ApplicationController
	skip_before_filter :authenticate_admin!, :only => :results

=begin
		Active
		Time elapsed
		Template used
		Emails Sent
		Victim Clicks
		Visits

		Victim Table
		------------
		Email address
		Sent
		Clicked 
		How many visits


=end

	def index
		list
		render('list')
	end

	def list
		# gather the launched campaigns
		@campaigns = Campaign.launched.page(params[:page]).per(8)
	end

	def visit_pool
		@visits = 0
		victims = Victim.where(campaign_id: params[:id])
		victims.each do |victim|
			@visits.append(Visit.where(Victim_id: victim.id)).size
		end
	end

	def image
		victims = Victim.where(:uid => params[:uid])
		visit = Visit.new()
		victim = victims.first()
		visit.Victim_id = victim.id
		visit.browser = request.env["HTTP_USER_AGENT"]
		visit.ip_address = request.env["REMOTE_ADDR"]
		visit.extra = "SOURCE: EMAIL"
		visit.save()
		send_file File.join(Rails.root.to_s, "public", "tracking_pixel.png"), :type => 'image/png', :disposition => 'inline'
	end

	def stats
=begin
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@email_settings = EmailSettings.find_by_id(params[:id])
		@template = Template.find_by_id(@campaign.template_id)
		@victims = Victim.where(:campaign_id => params[:id])

		@apache_data = parse_apache_logs(@campaign_settings, @campaign)

		# catch if an error was thrown on parse_apache_logs
		if @apache_data[:error]
			flash[:notice] = "#{@apache_data[:error]}"
			redirect_to(:action => 'list')
			return false
		end

		@ip_addresses = @apache_data[:ip_addresses]

		# display password if it exists
		passwd_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", "passwd.txt")
		if File.exist?(passwd_location)
			# read passwd file
			@passwd = File.read(passwd_location)
		else
			@passwd = nil
		end

		@location_object = []
		@apache_data[:ip_addresses].each do |ip_address|
			@location_object << Geokit::Geocoders::MultiGeocoder.geocode(ip_address).ll
		end
=end
	end


	def results
		finish = "start, "
		if params[:uid]
			finish += "uid check, "
			victims = Victim.where(:uid => params[:uid])
			finish += "length " + victims.length.to_s + ", "
			if victims.length > 0
				finish += "over 1, "
				v = victims.first()
				visit = Visit.new()
				visit.Victim_id = v.id
				if params[:browser_info]
					finish += "browser info, "
					visit.browser = params[:browser_info]
				end
				if params[:ip_address]
					finish += "ip address, "
					visit.ip_address = params[:ip_address]
				end
				if params[:extra]
					finish += "extra, "
					visit.extra = params[:extra]
				end
				visit.save()
			end
		end

		render text: finish
	end

	def stats_sum
		# Campaign for the reports
		@campaign = Campaign.find_by_id(params[:id])

		# Time since campaign was started.
		t = (Time.now - @campaign.created_at)
		@time = "%sD - %sH - %sM - %sS" % [(((t/60)/60)/24).floor, ((((t)/60)/60)% 24).floor, ((t / 60) % 60).floor, (t % 60).floor]

		# Name of template.
		@template_name = Template.where(id: ((@campaign).template_id)).first.name

		# Total number of emails sent.
		@emails_sent =  Victim.where(:campaign_id => @campaign.id).count

		# Unique vistors.
		@uvic = 0

		# Total visits to the website.
		@visits = 0

		# Total opened
		@opened = 0


		Victim.where(campaign_id: params[:id]).each do |victim|
			s = Visit.where(Victim_id: victim.id).size
			if (s > 0)
				@uvic = @uvic + 1
				@visits = @visits + s
			end
			o = Visit.where(:Victim_id => victim.id, :extra => "SOURCE: EMAIL").size
			if (o > 0)
				@opened = @opened + 1
			end
		end

		@jsonToSend = Hash.new()
		@jsonToSend["campaign_name"] = @campaign.name
		@jsonToSend["time"] = @time
		@jsonToSend["active"] = @campaign.active
		@jsonToSend["template"] = @template_name
		@jsonToSend["sent"] = @emails_sent
		@jsonToSend["opened"] = @opened
		@jsonToSend["clicked"] = @uvic

		render json: @jsonToSend
	end

	def victims_list 
		jsonToSend = Hash.new()
		jsonToSend["aaData"] = Array.new(Victim.where(campaign_id: params[:id]).count)
		i = 0
		Victim.where(campaign_id: params[:id]).each do |victim|
			imageSeen = Visit.where(:victim_id => victim.id).where('extra LIKE ?', "%EMAIL%").count > 0 ? "Yes" : "No"
			emailSent = Campaign.where(:id => victim.campaign_id).first().email_sent ? "Yes" : "No"
			emailClicked =  Visit.where(:victim_id => 1).where(:extra => nil).count + Visit.where(:victim_id => 1).where('extra not LIKE ?', "%EMAIL%").count > 0 ? "Yes" : "No"
			emailSeen = Visit.where(:victim_id => victim.id).last() != nil ? Visit.where(:victim_id => victim.id).last().created_at : "N/A"
			jsonToSend["aaData"][i] = [victim.uid,victim.email_address,emailSent,imageSeen,emailClicked,emailSeen]
			i += 1
		end

		render json: jsonToSend
	end

	def uid

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


	def logs; prepare_details; end
	def ip_addresses; prepare_details; end
	def browsers; prepare_details; end
	def visitors; prepare_details; end

	def prepare_details
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@apache_data = parse_apache_logs(@campaign_settings, @campaign)
	end

	def passwords
		@campaign = Campaign.find_by_id(params[:id])
		@template = Template.find_by_id(@campaign.template_id)
		passwd_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", "passwd.txt")
		if File.exist?(passwd_location)
			# read passwd file
			@passwd = File.open(passwd_location, 'r')
		else
			@passwd = nil
		end
	end

	def parse_apache_logs(campaign_settings, campaign)
		begin
			log = Rails.root.to_s + "/log/www-#{campaign_settings.fqdn}-#{campaign.id}-access.log"
			logs, visitors, browsers, ip_addresses = [], [], [], []

			File.open(log, 'r').each_line do |line|
				# read each line
				if line =~ /GET/ and line =~ /200/

					# parse and decode email address
					visitors << enum_visitors(line)

					# add to logs
					logs << line

					# parse the browser type
					browser = line.split('"')[5]

					# add to browser collection
					browsers << browser

					# parse ip addresses
					ip_address = line.split(' ')[0]
					#next if ip_address =~ / /
					ip_addresses << ip_address
				end
			end

			visitors.delete_if {|x| x == nil}
			uniq_visitors = visitors.uniq

			browsers.delete_if {|x| x == nil or x =~ /-/}
			uniq_browsers = browsers.uniq

			ip_addresses.delete_if {|x| x == nil}
			#if ip_addresses
				uniq_ip_addresses = ip_addresses.uniq
			#end

			apache_data = { :logs => logs, :visitors => uniq_visitors, :browsers => uniq_browsers, :ip_addresses => ip_addresses.uniq }
			return apache_data
		rescue => e
			apache_data = {:error => e}
			return apache_data
		end
	end

	def download_logs
		@campaign = Campaign.find_by_id(params[:id])
		logfile_name = Rails.root.to_s + "/log/www-#{@campaign.campaign_settings.fqdn}-#{@campaign.id}-access.log"

		begin
			# force browser to download file
			send_file logfile_name, :type => 'application/zip', :disposition => 'attachment', :filename => Pathname.new(logfile_name).basename
		rescue => e
			flash[:notice] = "Download Error: #{e}"
			redirect_to(:action => 'logs', :id => params[:id])
		end
	end

	def enum_visitors(line)
		if line.include?('id=')
			first = line.split('id=')[1]
			junk = first.split(" ")
			visitor = Base64.decode64(junk[0])
			return visitor
		else
			return visitor
		end
	end

	def clear_logs
		@campaign = Campaign.find_by_id(params[:id])

		if ReportsController.clear_apache_logs(@campaign)
			flash[:notice] = "Logs Cleared"
			redirect_to(:action => 'stats', :id => params[:id])
		else
			flash[:notice] = "Error: #{e}"
			redirect_to(:action => 'stats', :id => params[:id])
		end		
	end

	def self.clear_apache_logs(campaign)
		logfile_name = Rails.root.to_s + "/log/www-#{campaign.campaign_settings.fqdn}-#{campaign.id}-access.log"

		# clear apache log file
		begin
			File.open(logfile_name, 'w') {|file| file.truncate(0) }
		rescue
			return false
		end
	end

end

