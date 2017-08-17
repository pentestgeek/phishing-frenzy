# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  template_id :integer
#  name        :string(255)
#  description :string(255)
#  active      :boolean          default(FALSE)
#  scope       :integer
#  emails      :text(65535)
#  email_sent  :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  test_email  :string(255)
#  admin_id    :integer
#

require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
