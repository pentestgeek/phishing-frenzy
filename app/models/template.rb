class Template < ActiveRecord::Base
	has_many :campaigns

	attr_accessible :name, :description, :location, :notes

	validates :name, :presence => true, :length => { :maximum => 255 }
	validates :location, :presence => true, :length => { :maximum => 255 }

	before_validation :remove_spaces
	after_validation :manage_template_files

	def remove_spaces
		# ensure spaces are removed from location attribute
		if self.new_record?
			self.location = self.location.parameterize("_")
		else
			self.location = self.location.parameterize("_")
		end
	end

	def manage_template_files
		# if new template create files else move files if needed
		if self.new_record?
			create_template
		else
			move_template if self.location_changed?
		end
	end

	def move_template
		# append random string if folder exists
		if Template.folder_exists?(self.location)
			original_location = self.location_was
			self.location = "#{self.location}_#{Template.random_string}"
			move_template_folders(original_location, self.location)
		else
			move_template_folders(self.location_was, self.location)
		end
	end

	def create_template
		# append random string if folder exists
		if Template.folder_exists?(self.location)
			self.location = "#{self.location}_#{Template.random_string}"
			create_template_folders
		else
			create_template_folders
		end
	end

	def create_template_folders
		# create defaulte template folders
		Dir.mkdir(File.join(Rails.root.to_s, 'public', 'templates', self.location), 0700)
		Dir.mkdir(File.join(Rails.root.to_s, 'public', 'templates', self.location, 'email'), 0700)
		Dir.mkdir(File.join(Rails.root.to_s, 'public', 'templates', self.location, 'www'), 0700)
		File.new(File.join(Rails.root.to_s, 'public', 'templates', self.location, 'email', 'email.txt'), 0700)
		File.new(File.join(Rails.root.to_s, 'public', 'templates', self.location, 'www', 'index.php'), 0700)
	end

	def move_template_folders(from, to)
		FileUtils.mv(File.join(Rails.root.to_s, 'public', 'templates', from), 
			File.join(Rails.root.to_s, 'public', 'templates', to))
	end

	def self.folder_exists?(location)
		if File.directory? File.join(Rails.root.to_s, 'public', 'templates', location)
			return true
		else
			return false
		end
	end

	def self.random_string
		(0...8).map { (65 + rand(26)).chr }.join
	end
end
