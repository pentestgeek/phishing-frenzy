class CreateCampaignSettings < ActiveRecord::Migration
	def change
		create_table :campaign_settings do |t|
			t.integer "campaign_id"
			t.string "fqdn"
			t.string "phishing_url"
			t.string "apache_directory_root"
			t.string "apache_directory_index"
			t.boolean "track_uniq_visitors", :default => true
			t.boolean "track_hits", :default => true
			t.boolean "iptable_restrictions", :default => false
			t.boolean "schedule_campaign", :default => false
			t.boolean "use_beef", :default => false
			t.timestamps
		end
			add_index("campaign_settings", "campaign_id")
	end
end
