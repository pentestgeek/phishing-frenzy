class CreateBaits < ActiveRecord::Migration
  def change
    create_table :baits do |t|
      t.string :to
      t.string :from
      t.string :status
      t.string :message
      t.integer :blast_id

      t.timestamps
    end
  end
end
