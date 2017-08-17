# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string(255)
#  attachable_id   :integer
#  attachable_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  function        :string(255)      default("website")
#

class Attachment < ActiveRecord::Base

  attr_accessible :file, :function, :zipped, :directory_index

  belongs_to :attachable, :polymorphic => true

  mount_uploader :file, FileUploader

  FUNCTIONS =   [['Website File', 'website'],
                ['E-mail', 'email'],
                ['Image Attachment', 'attachment'],
                ['File Attachment', 'file_attachment']]
end
