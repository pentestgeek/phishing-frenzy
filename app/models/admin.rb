# == Schema Information
#
# Table name: admins
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  username               :string(255)
#  password               :string(255)
#  salt                   :string(255)
#  active                 :boolean          default(TRUE)
#  notes                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  approved               :boolean          default(FALSE), not null
#

require 'digest/sha1'

class Admin < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :rememberable, :trackable, :registerable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :username, :name, :email, :approved, :password, :password_confirmation, :remember_me

	has_paper_trail on: [:update], only: [:current_sign_in_at, :current_sign_in_ip]

	validates :name, presence: true, length: { maximum: 255 }
	validates :username, presence: true, length: { maximum: 255 }
	validates :email, presence: true, length: { maximum: 255 }
	validates_format_of :name, :with => /[A-Za-z\d]([-\w]{,498}[A-Za-z\d])?/i, :message => "Invalid Name: Alphanumerics only"
	validates_format_of :username, :with => /[A-Za-z\d]([-\w]{,498}[A-Za-z\d])?/i, :message => "Invalid Username: Alphanumerics only"

	scope :sorted, -> { order("admins.name ASC") }

	def active_for_authentication?
		super && approved?
	end

	def inactive_message
		if !approved?
			:not_approved
		else
			super # Use whatever other message
		end
	end

end
