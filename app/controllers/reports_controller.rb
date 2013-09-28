class ReportsController < ApplicationController
	before_filter :confirm_logged_in

	def index
		list
		render('list')
	end

	def list
		# gather the launched campaigns
		@campaigns = Campaign.launched
	end

	def stats
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@email_settings = EmailSettings.find_by_id(params[:id])
		@template = Template.find_by_id(@campaign.template_id)
		@logs, @visitors, @location, @browsers, @ip_addresses = parse_apache_logs(@campaign_settings, @campaign)
		@victims = Victims.where(:campaign_id => params[:id])
		passwd_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", "passwd.txt")
		if File.exist?(passwd_location)
			# read passwd file
			@passwd = File.read(passwd_location)
		else
			@passwd = nil
		end

		@location_object = []
		#@ip_addresses = ['4.4.4.4', '98.139.183.24', '74.113.233.95']
		@ip_addresses.each do |ip_address|
			@location_object << Geokit::Geocoders::MultiGeocoder.geocode(ip_address).ll
		end

		if @refresh
			return true
		else
			return false
		end
	end

	def logs
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@logs, @visitors, @location, @browsers, @ip_addresses = parse_apache_logs(@campaign_settings, @campaign)
	end

	def ip_addresses
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@logs, @visitors, @location, @browsers, @ip_addresses = parse_apache_logs(@campaign_settings, @campaign)
	end

	def browsers
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@logs, @visitors, @location, @browsers, @ip_addresses = parse_apache_logs(@campaign_settings, @campaign)
	end

	def visitors
		# generate statistics
		@campaign = Campaign.find_by_id(params[:id])
		@campaign_settings = CampaignSettings.find_by_id(params[:id])
		@logs, @visitors, @location, @browsers, @ip_addresses = parse_apache_logs(@campaign_settings, @campaign)
	end

	def passwords
		@template = Template.find_by_id(params[:id])
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

			return logs, uniq_visitors, location, uniq_browsers, ip_addresses.uniq
		rescue
			return false
		end
	end

	def enum_visitors(line)
		if line.include?('id=')
			#first = line.split('id=')[0]
			second = line.split('id=')[1]
			junk = second.split(" ")
			visitor = Base64.decode64(junk[0])
			return visitor
		else
			return visitor
		end
	end

end
