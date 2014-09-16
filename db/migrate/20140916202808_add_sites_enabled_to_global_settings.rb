class AddSitesEnabledToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :sites_enabled_path, :string, default: '/etc/apache2/sites-enabled'
    remove_column :global_settings, :path_apache_httpd
  end
end
