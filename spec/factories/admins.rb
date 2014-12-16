FactoryGirl.define do
  trait :unapproved do
    approved false
  end

  factory :admin do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password "SecretPasswd123!"
    password_confirmation "SecretPasswd123!"
    approved true
  end

end
