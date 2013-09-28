class CreateEmailSettings < ActiveRecord::Migration
	def change
		create_table :email_settings do |t|
			t.integer "campaign_id"
			t.string "to"
			t.string "cc"
			t.string "bcc"
			t.string "from"
			t.string "display_from"
			t.string "subject"
			t.string "phishing_url"
			t.string "smtp_server"
			t.string "smtp_server_out"
			t.integer "smtp_port"
			t.string "smtp_username"
			t.string "smtp_password"
			t.integer "emails_sent", :default => 0
			t.timestamps
		end
		add_index("email_settings", "campaign_id")
	end
end
