# == Schema Information
#
# Table name: admins
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  username               :string(255)
#  password               :string(255)
#  salt                   :string(255)
#  active                 :boolean          default(TRUE)
#  notes                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  approved               :boolean          default(FALSE), not null
#

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
