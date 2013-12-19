class Template < ActiveRecord::Base
	has_many :campaigns

	attr_accessible :name, :description, :location, :notes, :attachments_attributes

	validates :name, :presence => true, :length => { :maximum => 255 }
	validates :location, :presence => true, :length => { :maximum => 255 }

  has_many :attachments, :as => :attachable

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
    attachments.where(function: 'website').all
  end

  def email_files
    attachments.where(function: 'email').all
  end

  def images
    attachments.where(function: 'attachment').all.select do |attachment|
      attachment.file.url =~ /[jpg|png|gif]$/
    end
  end

end
