class AddCommandApacheStatusToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :command_apache_status, :string
  end
end
