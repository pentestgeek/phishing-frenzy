class CreateGlobalSettings < ActiveRecord::Migration
	def change
	create_table :global_settings do |t|
		t.string "command_apache_restart"
		t.string "path_apache_httpd"
		t.integer "smtp_timeout", :default => 5
		t.timestamps
	end
	end
end
