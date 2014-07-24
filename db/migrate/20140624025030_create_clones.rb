class CreateClones < ActiveRecord::Migration
  def change
    create_table :clones do |t|
      t.string :name
      t.string :status
      t.text :url
      t.text :page

      t.timestamps
    end
  end
end
