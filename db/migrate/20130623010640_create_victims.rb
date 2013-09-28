class CreateVictims < ActiveRecord::Migration
	def change
		create_table :victims do |t|
			t.string "email_address"
			t.string "campaign_id"
			t.timestamps
		end
	end
end
