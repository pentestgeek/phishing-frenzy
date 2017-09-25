# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  victim_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  browser    :string(255)
#  ip_address :string(255)
#  extra      :string(255)
#

class Visit < ActiveRecord::Base
  belongs_to :victim
  # attr_accessible :title, :body
end
