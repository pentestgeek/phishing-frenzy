# == Schema Information
#
# Table name: victims
#
#  id            :integer          not null, primary key
#  email_address :string(255)
#  campaign_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#  uid           :string(255)
#  firstname     :string(255)
#  lastname      :string(255)
#  archive       :boolean          default(FALSE)
#  sent          :boolean          default(FALSE)
#

class Victim < ActiveRecord::Base
	belongs_to :campaign
	has_many :visits, dependent: :destroy

	validates_format_of :email_address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates_uniqueness_of :email_address, scope: :campaign_id
	before_create :default_values

	attr_accessible :email_address, :uid, :campaign_id, :firstname, :lastname

	def default_values
		self.uid = (0...8).map { (65 + rand(26)).chr }.join 	
	end

  def clicked?
    # determine if victim has clicked on link or not
    self.visits.where('extra is null OR extra not LIKE ?', "%EMAIL%").empty? ? false : true
  end

  def opened?
    # determine if victim has opened on link or not
    self.visits.empty? ? false : true
  end

  def password?
    # determine if victim has enetered a password or not
    self.visits.where('extra LIKE ?', "%password%").empty? ? false : true
  end

end
