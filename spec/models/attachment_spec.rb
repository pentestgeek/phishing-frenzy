# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string(255)
#  attachable_id   :integer
#  attachable_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  function        :string(255)      default("website")
#

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to(:attachable) }
  it 'valid record' do
    expect(build(:attachment)).to be_valid
  end
end
