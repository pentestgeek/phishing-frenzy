class AddBeefUrlToCampaignSettings < ActiveRecord::Migration
  def change
    add_column :campaign_settings, :beef_url, :string
  end
end
