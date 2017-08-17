# == Schema Information
#
# Table name: ssls
#
#  id          :integer          not null, primary key
#  filename    :string(255)
#  function    :string(255)
#  campaign_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class SslTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
