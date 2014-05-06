class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :victim

      t.timestamps
    end
    add_index :visits, :victim_id
  end
end
