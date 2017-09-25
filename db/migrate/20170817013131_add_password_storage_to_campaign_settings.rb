class AddPasswordStorageToCampaignSettings < ActiveRecord::Migration
  def change
    add_column :campaign_settings, :require_uid, :boolean, default: true
    add_column :campaign_settings, :password_storage, :boolean, default: true
  end
end
