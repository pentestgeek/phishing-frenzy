class Template < ActiveRecord::Base
	has_many :campaigns

	attr_accessible :name, :description, :notes, :attachments_attributes, :directory_index

	validates :name, presence: true, length: { :maximum => 255 }
	validates_with TemplateValidator

	has_many :attachments, as: :attachable, dependent: :destroy

	accepts_nested_attributes_for :attachments

	def email_directory
		File.dirname(email_files.first.file.current_path)
	end

	def email_directory_url
		File.dirname(email_files.first.file.url)
	end

	def email_template_path
		"../../public#{email_directory_url}"
	end

	def website_files
		attachments.where('function like "website%"').all
	end

	def email_files
		attachments.where(function: 'email').all
	end

	def images
		attachments.where(function: 'attachment').all.select do |attachment|
			attachment.file.url =~ /[jpg|png|gif]$/
		end
	end

	def index_file
		directory_index.blank? ? 'index.php' : directory_index
	end

end
