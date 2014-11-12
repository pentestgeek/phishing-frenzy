class AddSslToCampaignSettings < ActiveRecord::Migration
  def change
    add_column :campaign_settings, :ssl, :boolean
  end
end
