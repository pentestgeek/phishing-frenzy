class AddBeefApikeyToCampaignSettings < ActiveRecord::Migration
  def change
    add_column :campaign_settings, :beef_apikey, :string
  end
end
