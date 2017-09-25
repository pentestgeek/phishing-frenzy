# == Schema Information
#
# Table name: baits
#
#  id         :integer          not null, primary key
#  to         :string(255)
#  from       :string(255)
#  status     :string(255)
#  message    :string(255)
#  blast_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Bait < ActiveRecord::Base
  attr_accessible :blast_id, :from, :message, :status, :to
  belongs_to :blast, counter_cache: true
end
