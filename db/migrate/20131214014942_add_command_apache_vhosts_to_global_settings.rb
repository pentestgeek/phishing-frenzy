class AddCommandApacheVhostsToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :command_apache_vhosts, :string, default: 'apache2ctl -S'
  end
end
