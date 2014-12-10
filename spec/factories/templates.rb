FactoryGirl.define do
  factory :template, :class => 'Template' do
    sequence(:name) {|n| "Template Name #{n}"}
    sequence(:description) {|n| "Template Description #{n}"}
    directory_index "index.php"
  end
end
