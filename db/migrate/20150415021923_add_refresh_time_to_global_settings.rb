class AddRefreshTimeToGlobalSettings < ActiveRecord::Migration
  def change
  	add_column :global_settings, :reports_refresh, :integer, default: 15
  end
end
