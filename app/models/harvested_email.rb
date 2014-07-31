class HarvestedEmail < ActiveRecord::Base
  belongs_to :email_search

  attr_accessible :email, :original, :group, :url, :email_search_id

  validates_uniqueness_of :email, scope: :email_search_id
  before_validation :normalize_email

  private

  def normalize_email
    self.original = self.email[0]
    symbol =        self.email[1]
    if self.email[1].match(/@/)
      self.email = self.original
    else
      self.email = self.original.gsub(self.email[1], '@')
    end
  end

end
