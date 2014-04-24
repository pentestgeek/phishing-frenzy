class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :Victim

      t.timestamps
    end
    add_index :visits, :Victim_id
  end
end
