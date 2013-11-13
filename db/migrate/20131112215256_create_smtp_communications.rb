class CreateSmtpCommunications < ActiveRecord::Migration
	def change
		create_table :smtp_communications do |t|
			t.string "to"
			t.string "from"
			t.string "status"
			t.string "string"
			t.integer "campaign_id"
			t.timestamps
		end
		add_index("smtp_communications", "campaign_id")
	end
end
