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

FactoryGirl.define do
  factory :template, :class => 'Template' do
    sequence(:name) {|n| "Template Name #{n}"}
    sequence(:description) {|n| "Template Description #{n}"}
    directory_index "index.php"
  end
end
