class Victim < ActiveRecord::Base
	belongs_to :campaign
	has_many :visits

	validates_format_of :email_address, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	before_create :default_values

	attr_accessible :email_address, :uid, :campaign_id, :firstname, :lastname

	def default_values
		self.uid = (0...8).map { (65 + rand(26)).chr }.join 	
	end

end
