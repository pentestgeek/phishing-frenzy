class Attachment < ActiveRecord::Base

  attr_accessible :file, :function, :zipped, :directory_index

  belongs_to :attachable, :polymorphic => true

  mount_uploader :file, FileUploader

  FUNCTIONS =   [['Website File', 'website'],
                ['E-mail', 'email'],
                ['Image Attachment', 'attachment'],
                ['File Attachment', 'file_attachment']]
end
