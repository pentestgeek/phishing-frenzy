class HookedBrowsers < ActiveRecord::Base
  belongs_to :victim

  attr_accessible :hb_id, :ip, :btype, :bversion, :os, :platform, :language, :plugins, :city, :country

end
