class HookedBrowser < ActiveRecord::Base
  belongs_to :victim

  attr_accessible :hb_id, :ip, :victim_id, :btype, :bversion, :os, :platform, :language, :plugins, :city, :country

end
