class CreateBlasts < ActiveRecord::Migration
  def change
    create_table :blasts do |t|
      t.integer :campaign_id
      t.boolean :test, default: false
      t.integer :number_of_targets
      t.integer :emails_sent, default: 0
      t.string :message, default: "Started  "

      t.timestamps
    end
  end
end
