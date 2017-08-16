class UriValidator < ActiveModel::Validator
  require 'uri'

  def validate(uri)
    !!URI.parse(uri)
  rescue URI::InvalidURIError
    false
  end
end
