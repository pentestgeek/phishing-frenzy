class EmailSettings < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible 	:campaign_id, :to, :cc, :bcc, :from, :display_from, :subject, :phishing_url, 
  					:smtp_server, :smtp_username, :smtp_password, :smtp_port, :smtp_server_out

  validates :campaign_id, :presence => true,
  	:length => { :maximum => 255 }
  validates :display_from,
  	:length => { :maximum => 255 }, :allow_nil => true
  validates :subject,
  	:length => { :maximum => 255 }, :allow_nil => true
  validates :smtp_server,
  	:length => { :maximum => 255 }, :allow_nil => true
  validates :smtp_server_out,
  	:length => { :maximum => 255 }, :allow_nil => true
  validates :smtp_username,
  	:length => { :maximum => 255 }, :allow_nil => true
  validates :smtp_password,
  	:length => { :maximum => 255 }, :allow_nil => true
  validates :smtp_port, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 65535 },
  	:length => { :maximum => 5 }, :allow_nil => true

end
