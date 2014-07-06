class AddDelayToCampaignSettings < ActiveRecord::Migration
  def change
  	add_column :campaign_settings, :smtp_delay, :integer, :default => 0
  end
end
