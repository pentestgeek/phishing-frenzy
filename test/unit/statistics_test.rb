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

require 'test_helper'

class StatisticsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
