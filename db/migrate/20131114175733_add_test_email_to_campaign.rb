class AddTestEmailToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :test_email, :string
  end
end
