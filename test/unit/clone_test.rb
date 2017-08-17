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

require 'test_helper'

class CloneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
