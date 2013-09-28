class CreateTemplates < ActiveRecord::Migration
	def change
		create_table :templates do |t|
			t.integer "campaign_id"
			t.string "name"
			t.string "description"
			t.string "location"
			t.string "notes"
			t.timestamps
		end
			add_index("templates", "campaign_id")
	end
end
