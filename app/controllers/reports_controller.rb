class ReportsController < ApplicationController
	before_filter :confirm_logged_in

	def index
		list
		render('list')
	end

	def list
		# gather the launched campaigns
		@campaigns = Campaign.launched.page(params[:page]).per(8)
	end

	def stats
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@email_settings = EmailSettings.find_by_id(params[:id])
		@template = Template.find_by_id(@campaign.template_id)
		@victims = Victims.where(:campaign_id => params[:id])

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

end
