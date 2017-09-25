# == Schema Information
#
# Table name: harvested_emails
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  group           :string(255)
#  url             :text(65535)
#  email_search_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  original        :string(255)
#

require 'test_helper'

class HarvestedEmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
