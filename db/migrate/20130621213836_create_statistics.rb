class CreateStatistics < ActiveRecord::Migration
	def change
		create_table :statistics do |t|
			t.integer "campaign_id"
			t.string "views"
			t.string "downloads"
			t.string "unique_visitors"
			t.string "visitors_name"
			t.timestamps
		end
	end
end
