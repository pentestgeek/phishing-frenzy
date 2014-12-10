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
