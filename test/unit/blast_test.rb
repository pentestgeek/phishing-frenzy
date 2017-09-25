# == Schema Information
#
# Table name: blasts
#
#  id                :integer          not null, primary key
#  campaign_id       :integer
#  test              :boolean          default(FALSE)
#  number_of_targets :integer
#  emails_sent       :integer          default(0)
#  message           :string(255)      default("Started  ")
#  created_at        :datetime
#  updated_at        :datetime
#  baits_count       :integer          default(0)
#

require 'test_helper'

class BlastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
