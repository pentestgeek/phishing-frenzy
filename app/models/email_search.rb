class EmailSearch < ActiveRecord::Base
  has_many :harvested_emails, dependent: :destroy

  attr_accessible :domain, :crawls, :harvested_email_id
end
