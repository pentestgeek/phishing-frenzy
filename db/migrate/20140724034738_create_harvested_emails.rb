class CreateHarvestedEmails < ActiveRecord::Migration
  def change
    create_table :harvested_emails do |t|
      t.string :email
      t.string :group
      t.text :url
      t.references :email_search

      t.timestamps
    end
    add_index :harvested_emails, :email_search_id
  end
end
