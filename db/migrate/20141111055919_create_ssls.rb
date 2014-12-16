class CreateSsls < ActiveRecord::Migration
  def change
    create_table :ssls do |t|
      t.string :filename
      t.string :function
      t.references :campaign, index: true
      t.timestamps
    end
  end
end
