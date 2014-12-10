FactoryGirl.define do
  trait :unapproved do
    approved false
  end

  factory :admin do
    sequence(:username) {|n| "Username#{n}" }
    sequence(:email) {|n| "username#{n}@phishingfrenzy.local" }
    name "Username Name"
    password "SecretPasswd123!"
    password_confirmation "SecretPasswd123!"
    approved true
  end

end
