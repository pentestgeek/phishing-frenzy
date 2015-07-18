class RemoveCommandsFromGlobalSettings < ActiveRecord::Migration
  def change
    remove_column :global_settings, :command_apache_status
    remove_column :global_settings, :command_apache_restart
    remove_column :global_settings, :command_apache_vhosts
    remove_column :global_settings, :sites_enabled_path
  end
end
