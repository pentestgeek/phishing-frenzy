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

FactoryGirl.define do
	trait :templated do
		sequence(:template_id) {|n| n }
	end

  trait :launched do
    email_sent true
  end

  factory :campaign do
    sequence(:name) {|n| "Campaign Name #{n}" }
    sequence(:description) {|n| "Campaign Description #{n}" }
    active false
    created_at Time.now
    updated_at Time.now
  end

end
