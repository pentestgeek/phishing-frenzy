class CreateAdmins < ActiveRecord::Migration
	def change
		create_table :admins do |t|
			t.string "name"
			t.string "username"
			t.string "password"
			t.string "salt"
			t.boolean "active", :default => true
			t.string "notes"
			t.timestamps
		end
	end
end
