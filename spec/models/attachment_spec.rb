require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to(:attachable) }
  it 'valid record' do
    expect(build(:attachment)).to be_valid
  end
end
