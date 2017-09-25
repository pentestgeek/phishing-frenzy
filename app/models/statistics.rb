# == Schema Information
#
# Table name: statistics
#
#  id              :integer          not null, primary key
#  campaign_id     :integer
#  views           :string(255)
#  downloads       :string(255)
#  unique_visitors :string(255)
#  visitors_name   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Statistics < ActiveRecord::Base
	belongs_to :campaign
end
