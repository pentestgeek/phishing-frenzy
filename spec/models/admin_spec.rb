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
