class AddNamesToVictims < ActiveRecord::Migration
  def change
    add_column :victims, :firstname, :string
    add_column :victims, :lastname, :string
  end
end
