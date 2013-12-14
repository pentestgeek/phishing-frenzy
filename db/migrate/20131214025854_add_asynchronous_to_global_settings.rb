class AddAsynchronousToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :asynchronous, :boolean, default: false
  end
end
