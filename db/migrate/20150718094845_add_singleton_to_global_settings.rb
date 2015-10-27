class AddSingletonToGlobalSettings < ActiveRecord::Migration
  def change
    add_column :global_settings, :singleton, :integer
    add_index :global_settings, :singleton, unique: true
  end
end
