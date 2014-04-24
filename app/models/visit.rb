class Visit < ActiveRecord::Base
  belongs_to :Victim
  # attr_accessible :title, :body
end
