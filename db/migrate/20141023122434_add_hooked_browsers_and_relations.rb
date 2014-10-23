class AddHookedBrowsersAndRelations < ActiveRecord::Migration
  def change
    create_table :hooked_browsers do |t|

      #:ip, :type, :version, :os, :platform, :language, :plugins, :city, :country
      t.integer "victim_id"
      t.string "hb_id"
      t.string "ip"
      t.string "type"
      t.string "version"
      t.string "os"
      t.string "platform"
      t.string "language"
      t.string "plugins"
      t.string "city"
      t.string "country"

      t.timestamps
    end
    add_index("hooked_browsers", "victim_id")
  end
end
