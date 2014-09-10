class AddBeefUrlToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :beef_url, :string
  end
end
