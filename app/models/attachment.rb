class Attachment < ActiveRecord::Base
  attr_accessible :file, :function

  belongs_to :attachable, :polymorphic => true

  mount_uploader :file, FileUploader
end
