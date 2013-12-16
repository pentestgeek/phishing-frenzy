class Campaign < ActiveRecord::Base
	# relationships
	belongs_to :template
	has_one :campaign_settings, dependent: :destroy
	has_one :email_settings, dependent: :destroy
	has_many :statistics
	has_many :victims
	has_many :smtp_communications
  has_many :blasts

	# allow mass asignment
	attr_accessible :name, :description, :active, :emails, :scope, :template_id, :test_email

	# named scopes
	scope :active, where(:active => true)
	scope :launched, where(:email_sent => true)

	before_save :parse_email_addresses
	after_save :check_changes

	# validate form before saving
	validates :name, :presence => true,
		:length => { :maximum => 255 }
	validates :description,
		:length => { :maximum => 255 }
	validates :emails,
		:length => { :maximum => 60000 }
	validates :scope, :numericality => { :greater_than_or_equal_to => 0 },
		:length => { :maximum => 4 }, :allow_nil => true


	def test_victim
		v = Victim.new
		v.email_address = test_email
		v
	end

	private

	def parse_email_addresses
		if not self.emails.blank?
			# csv or carriage
			if self.emails.include? ","
				victims = self.emails.split(",")
				victims.each do |v|
					victim = Victim.new
					victim.campaign_id = self.id
					victim.email_address = v.strip
					victim.save
				end
			else
				victims = self.emails.split("\r\n")
				victims.each do |v|
					victim = Victim.new
					victim.campaign_id = self.id
					victim.email_address = v
					victim.save
				end
			end

			# clear the Campaigns.emails holder
			self.update_attribute(:emails, " ")
		end
	end

	def check_changes
		if campaign_settings == nil
			return false
		end

		if self.changed?
			httpd = GlobalSettings.first.path_apache_httpd
			template = Template.find_by_id(self.template_id)

			# gather active campaigns
			active_campaigns = Campaign.active

			# flush httpd config
			File.open(httpd, 'w') {|file| file.truncate(0) }

			# write each active campaign to httpd
			active_campaigns.each do |campaign|
				File.open(httpd, "a+") do |f|
					template = Template.find_by_id(campaign.template_id)
					if template.nil?
						raise 'Template #{campaign.template_id} not found'

					else
						f.write(vhost_text(campaign.id, campaign.campaign_settings.fqdn, template.location))
					end
				end
			end

			# reload apache
			restart_apache = GlobalSettings.first.command_apache_restart
			system(restart_apache)
		end
	end

	def vhost_text(campaign_id, fqdn, template_location)
		approot = Rails.root

		vhost_text = <<-VHOST
			# #{fqdn}
			<VirtualHost *:80>
							ServerName #{fqdn}
							ServerAlias #{fqdn}
							ServerAlias www.#{fqdn}
							DocumentRoot #{approot}/public/templates/#{template_location}/www/
							DirectoryIndex index.php
							CustomLog     #{approot}/log/www-#{fqdn}-#{campaign_id}-access.log combined
							ErrorLog      #{approot}/log/www-#{fqdn}-#{campaign_id}-error.log
			</VirtualHost>

		VHOST

		return vhost_text
	end

end
