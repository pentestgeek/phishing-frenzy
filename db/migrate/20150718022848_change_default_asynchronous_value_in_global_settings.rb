class ChangeDefaultAsynchronousValueInGlobalSettings < ActiveRecord::Migration
  def change
    change_column :global_settings, :asynchronous, :boolean, default: true
    GlobalSettings.update_all(asynchronous: true)
  end
end
