class CreateEmailSearches < ActiveRecord::Migration
  def change
    create_table :email_searches do |t|
      t.string :domain
      t.integer :crawls
      t.references :harvested_email

      t.timestamps
    end
    add_index :email_searches, :harvested_email_id
  end
end
