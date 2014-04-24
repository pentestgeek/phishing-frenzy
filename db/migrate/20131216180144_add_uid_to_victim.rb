class AddUidToVictim < ActiveRecord::Migration
  def change
    add_column :victims, :uid, :string
  end
end
