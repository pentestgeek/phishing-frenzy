require 'digest/sha1'

class Admin < ActiveRecord::Base
	attr_accessible :password, :salt, :name, :username, :passwd, :active
	#attr_protected :password, :salt
	# adding non-db attribute
	attr_accessor :passwd

	validates :name, :presence => true, :length => { :maximum => 255 }
	validates :username, :presence => true, :length => { :maximum => 255 }
	#validates :passwd, :presence => true, :length => { :maximum => 255 }

	before_save :create_hashed_password
	after_save :clear_password

	scope :sorted, order("admins.name ASC")

	# make uniq salt
	def self.make_salt(username="")
		Digest::SHA1.hexdigest("Whats the #{username} at this #{Time.now}")
	end

	# hash the password using the salt
	def self.hash_with_salt(password="", salt="")
		Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
	end

	def self.authenticate(username="", passwd="")
		# query matching username
		user = Admin.find_by_username(username)
		if user && user.password_match?(passwd)
			return user
		else
			return false
		end
	end

	def password_match?(passwd="")
		password == Admin.hash_with_salt(passwd, salt)
	end

	private

	def create_hashed_password
		unless passwd.blank?
			# use self when assiging vals
			self.salt = Admin.make_salt(username) if salt.blank?
			self.password = Admin.hash_with_salt(passwd, salt)
		end
	end

	def clear_password
		# for security
		self.passwd = nil
	end
end
