class AddBeefApikeyToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :beef_apikey, :string
  end
end
