class EmailSearch < ActiveRecord::Base
  has_many :harvested_emails, dependent: :destroy

  attr_accessible :domain, :harvested_email_id
end
