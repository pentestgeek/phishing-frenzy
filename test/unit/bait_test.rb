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

require 'test_helper'

class BaitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
