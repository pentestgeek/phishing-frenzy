class AddArchiveToVictim < ActiveRecord::Migration
  def change
    add_column :victims, :archive, :boolean, default: false
    add_column :victims, :sent, :boolean, default: false
  end
end
