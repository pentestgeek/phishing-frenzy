class CreateCampaigns < ActiveRecord::Migration
	def change
	create_table :campaigns do |t|
		t.integer "template_id"
		t.string "name"
		t.string "description"
		t.boolean "active", :default => false
		t.integer "scope"
		t.text "emails"
		t.boolean "email_sent", :default => false
		t.timestamps
	end
	add_index("campaigns", "template_id")
	end
end
