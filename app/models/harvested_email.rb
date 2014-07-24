class HarvestedEmail < ActiveRecord::Base
  belongs_to :email_search

  attr_accessible :email, :group, :url, :email_search_id

  validates_uniqueness_of :email, scope: :email_search_id
end
