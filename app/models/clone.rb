# == Schema Information
#
# Table name: clones
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  status     :string(255)
#  url        :text(65535)
#  page       :text(65535)
#  created_at :datetime
#  updated_at :datetime
#

class Clone < ActiveRecord::Base
  attr_accessible :name, :page, :url
end
