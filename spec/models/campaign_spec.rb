require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it 'valid record' do
  	expect(build(:campaign)).to be_valid
  end
end
