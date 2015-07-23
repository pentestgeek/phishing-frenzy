class AddSiteUrlToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :site_url, :string, default: 'https://phishingfrenzy.local'
  end
end
