class AddOriginalToHarvestedEmail < ActiveRecord::Migration
  def change
    add_column :harvested_emails, :original, :string
  end
end
