class Visit < ActiveRecord::Base
  belongs_to :victim

  has_one :credential, dependent: :destroy
  # attr_accessible :title, :body
end
