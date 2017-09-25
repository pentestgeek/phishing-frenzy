# == Schema Information
#
# Table name: email_searches
#
#  id                 :integer          not null, primary key
#  domain             :string(255)
#  crawls             :integer
#  harvested_email_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class EmailSearch < ActiveRecord::Base
  has_many :harvested_emails, dependent: :destroy

  attr_accessible :domain, :crawls, :harvested_email_id
end
