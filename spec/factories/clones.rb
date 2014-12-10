FactoryGirl.define do
  factory :clone do
    sequence(:name) {|n| "Website Clone #{n}"}
    sequence(:url) {|n| "http://sub.website#{n}.com"}
    sequence(:page) {|n| "<html><head></head><body>#{n}</body></html>" }
  end

end
