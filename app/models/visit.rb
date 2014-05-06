class Visit < ActiveRecord::Base
  belongs_to :victim
  # attr_accessible :title, :body
end
