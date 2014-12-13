require 'fileutils'
require 'zip'

class Campaign < ActiveRecord::Base
  # relationships
  belongs_to :template
  has_one :campaign_settings, dependent: :destroy
  has_one :email_settings, dependent: :destroy
  has_many :ssl, dependent: :destroy
  has_many :victims, dependent: :destroy
  has_many :blasts, dependent: :destroy
  has_many :statistics
  has_many :smtp_communications
  has_many :baits, through: :blasts
  has_many :visits, through: :victims
  
  accepts_nested_attributes_for :email_settings, allow_destroy: true
  accepts_nested_attributes_for :campaign_settings, allow_destroy: true
  accepts_nested_attributes_for :ssl, allow_destroy: true#, :reject_if => proc {|attributes| attributes['filename'].blank?}

  # allow mass asignment
  attr_accessible :name, :description, :active, :emails, :scope, :template_id, :test_email, :ssl_attributes,:email_sent, :email_settings_attributes, :campaign_settings_attributes

  # named scopes
  scope :active, -> { where(active: true) }
  scope :launched, -> { where(email_sent: true) }

  before_save :parse_email_addresses
  before_validation :active_deps, :if => :active_changed?
  after_update :devops, :if => :active_changed?
  after_destroy :cleanup_apache
  after_create :create_deps

  # validate form before saving
  validates :name, :presence => true,
            :length => {:maximum => 255}
  validates :description,
            :length => {:maximum => 255}
  validates :emails,
            :length => {:maximum => 60000}
  validates :scope, :numericality => {:greater_than_or_equal_to => 0},
            :length => {:maximum => 4}, :allow_nil => true

  def create_deps
    Ssl.functions.each do |function|
      newSSL = ssl.new
      newSSL.campaign_id = id
      newSSL.function = function[0]
      newSSL.save(validate: false)
    end

    # create campaign settings and email settings for campaign
    CampaignSettings.create(campaign_id: id, fqdn: '')
    EmailSettings.create(campaign_id: id)
  end

  def clicks
    visits.where('extra is null OR extra not LIKE ?', "%EMAIL%").pluck(:victim_id).uniq.size
  end

  def opened
    visits.pluck(:victim_id).uniq.size
  end

  def sent
    victims.where(sent: true).size
  end

  def success
    self.sent == 0 ? 
        0 : (self.clicks.to_f / self.sent.to_f * 100.0).round(2)
  end

  def self.logfile(campaign)
    Rails.root.to_s + "/log/www-campaign-#{campaign.id}-access.log"
  end

  def get_binding
    @ssl = ssl
    @campaign_id = id
    @campaign_settings = campaign_settings
    @fqdn = campaign_settings.fqdn
    @template_location = deployment_directory
    @approot = Rails.root
    @directory_index = template.index_file
    binding
  end

  def beef_binding(beef_url)
    @beef_url = beef_url
    binding
  end

  def test_victim
    v = Victim.new
    v.email_address = test_email
    v
  end

  private

  def parse_email_addresses
    if not self.emails.blank?
      entry = self.emails.split("\r\n")[0]
      if entry.scan(/,/).count == 0
        # email
        parse_single_csv
      elsif entry.scan(/,/).count == 1
        # firstname, email
        parse_double_csv
      elsif entry.scan(/,/).count == 2
        # firstname, lastname, email
        parse_triple_csv
      end
      
      # clear the Campaigns.emails holder
      self.update_attribute(:emails, " ")
    end
  end

  def parse_single_csv
    victims = self.emails.split("\r\n")
    victims.each do |v|
      victim = Victim.new
      victim.campaign_id = self.id
      victim.firstname = ""
      victim.lastname = ""
      victim.email_address = v
      victim.save
    end
  end

  def parse_double_csv
    victims = self.emails.split("\r\n")
    victims.each do |v|
      firstname = v.split(",")[0].strip
      email = v.split(",")[1].strip
      victim = Victim.new
      victim.campaign_id = self.id
      victim.firstname = firstname
      victim.email_address = email
      victim.save
    end
  end

  def parse_triple_csv
    victims = self.emails.split("\r\n")
    victims.each do |v|
      firstname = v.split(",")[0].strip
      lastname = v.split(",")[1].strip
      email = v.split(",")[2].strip
      victim = Victim.new
      victim.campaign_id = self.id
      victim.firstname = firstname
      victim.lastname = lastname
      victim.email_address = email
      victim.save
    end
  end

  def vhost_text(campaign, virtual_host_type)
    template = ERB.new File.read(File.join(Rails.root, "app/views/campaigns/#{virtual_host_type}.txt.erb",))
    template.result(campaign.get_binding)
  end

  def check_changes
    # if campaign is active ensure we still have a FQDN on update
    if self.active
      if self.campaign_settings.phishing_url.to_s.empty?
        redirect_to campaign_path(self.id), notice: 'FQDN cannot be blank before going active'
        return
      end
    end
  end

  def active_deps
    # ensure we have a FQDN before going active
    if active.eql? true
      errors.add(:fqdn, "cannot be nil when making campaign active") unless campaign_settings.fqdn.present?

      # ensure we have write access to sites-enabled   
      unless File.writable?(GlobalSettings.first.sites_enabled_path)
        errors.add(:apache, "File Permission Issue: chmod -R 755 and chown www-data:www-data #{GlobalSettings.first.sites_enabled_path}")
      end
    end

    # check ssl deps if enabled and going active
    if campaign_settings.ssl and active.eql? true
      # validate we have certificate files
      ssl_status = self.ssl.map {|m| m.filename.present?}
      errors.add(:active, "process needs SSL certificate files uploaded for HTTPS") if ssl_status.include?(false)
    end
  end

  def devops
    active ? deploy : undeploy
  end

  def undeploy
    # remove phishing directory
    FileUtils.rm_rf deployment_directory
    # remove apache vhost file if exists
    FileUtils.rm_rf vhost_file if File.exists?(vhost_file)

    reload_apache
  end

  def deploy
    # determine if SSL is enabled on campaign
    virtual_host_type = self.campaign_settings.ssl ? "virtual_host_ssl" : "virtual_host"

    # write vhost config and restart apache
    write_vhost(virtual_host_type)
    reload_apache

    # deploy phishing website files
    FileUtils.mkdir_p(deployment_directory)
    template.website_files.each do |page|
      loc = File.join(deployment_directory, page[:file])
      # copy template files to deployment directory
      FileUtils.cp(page.file.current_path, loc)
      if File.extname(page.file.current_path) == '.php'
        File.open(loc, 'w') do |fo|
          # add php tracking tags to each website file
          tags = ERB.new File.read(File.join(Rails.root, "app/views/reports/tags.txt.erb"))
          # add beef script tags if enabled
          tags = self.campaign_settings.use_beef? ? tag_beef(tags) : tags.result
          fo.puts tags
          File.foreach(page.file.current_path) do |li|
            fo.puts li
          end
        end
      end
      if inflatable?(loc)
        inflate(loc, deployment_directory)
      end
    end
  end

  def write_vhost(vhost_type)
    # add vhost file to sites-enabled
    File.open(vhost_file, "w") do |f|
      template = Template.find_by_id(self.template_id)
      if template.nil?
        raise 'Template #{self.template_id} not found'
      else
        f.write(vhost_text(self, vhost_type))
      end
    end
  end

  def tag_beef(tags)
    beef = ERB.new File.read(File.join(Rails.root, "app/views/reports/beef.txt.erb"))
    return beef.result(self.beef_binding(select_beef_url)) + tags.result
  end

  def select_beef_url
    return campaign_settings.beef_url unless campaign_settings.beef_url.empty?
    return GlobalSettings.first.beef_url unless GlobalSettings.first.beef_url.empty?
    return "#{PhishingFramework::SITE_URL}:3000/hook.js"
  end

  def deployment_directory
    File.join(Rails.root, "public/deployed/campaigns", id.to_s)
  end

  def vhost_file
    "#{GlobalSettings.first.sites_enabled_path}/#{self.id}.conf"
  end

  def inflatable?(file)
    File.extname(file) == '.zip'
  end

  def inflate(file, destination)
    Zip::File.open(file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end

  def cleanup_apache
    # delete phishing files for campaign
    FileUtils.rm_rf deployment_directory
    # delete apache vhost configuration
    FileUtils.rm_rf vhost_file if File.exists?(vhost_file)
  end

  def reload_apache
    restart_apache = GlobalSettings.first.command_apache_restart
    system("#{restart_apache} > /dev/null")
  end

end
