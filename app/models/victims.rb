class Victims < ActiveRecord::Base
  belongs_to :campaign

  #validates :email_address, :uniqueness => true
  validates_format_of :email_address, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
end
