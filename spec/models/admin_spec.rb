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

require 'rails_helper'

RSpec.describe Admin, :type => :model do
  it "has a valid factory" do
    expect(create(:admin)).to be_valid
  end

  it "is invalid without username" do
    expect(build(:admin, username: nil)).to_not be_valid
  end

  it "is invalid without name" do
    expect(build(:admin, name: nil)).to_not be_valid
  end

  it "is invalid without email" do
    expect(build(:admin, email: nil)).to_not be_valid
  end

  it "is invalid without password" do
    expect(build(:admin, password: nil)).to_not be_valid
  end

  it "is invalid with password less than 8 characters" do
    expect(build(:admin, password: "short")).to_not be_valid
  end

  it "is invalid with non alpha numeric name format" do
    expect(build(:admin, name: '!@#{$%^&*}')).to_not be_valid
  end

  it "is invalid with non alpha numeric username format" do
    expect(build(:admin, username: '!@#{$%^&*}')).to_not be_valid
  end
  
end
