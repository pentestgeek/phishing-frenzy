# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  campaign_id     :integer
#  name            :string(255)
#  description     :string(255)
#  location        :string(255)
#  notes           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  directory_index :string(255)
#  admin_id        :integer
#

require 'rails_helper'

RSpec.describe Template, type: :model do
  it { should belong_to(:admin) }
  it { should have_many(:campaigns) }
  it { should have_many(:attachments) }
  it 'valid record' do
    expect(build(:template)).to be_valid
  end

  it 'Template.email_exists?' do
    template = create(:template)
    expect(template.email_files.present?).to be_falsey
  end
end
