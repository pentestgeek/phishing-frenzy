class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.string :username
      t.string :password

      t.timestamps
    end

    add_reference :credentials, :visit, index: true
  end
end
