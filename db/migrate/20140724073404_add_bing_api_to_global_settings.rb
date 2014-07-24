class AddBingApiToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :bing_api, :string
  end
end
