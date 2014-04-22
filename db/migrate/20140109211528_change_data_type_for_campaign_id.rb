class ChangeDataTypeForCampaignId < ActiveRecord::Migration
  def up
    change_table :victims do |t|
      t.change :campaign_id, :integer
    end
  end

  def down
    change_table :victims do |t|
      t.change :campaign_id, :string
    end
  end
end
