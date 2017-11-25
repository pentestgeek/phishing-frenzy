class AddOptionsToCampaignSettings < ActiveRecord::Migration
  def change
    add_column :campaign_settings, :robots_block, :boolean, default: true
    add_column :campaign_settings, :directory_index, :boolean, default: false
  end
end
