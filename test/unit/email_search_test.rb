# == Schema Information
#
# Table name: email_searches
#
#  id                 :integer          not null, primary key
#  domain             :string(255)
#  crawls             :integer
#  harvested_email_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class EmailSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
