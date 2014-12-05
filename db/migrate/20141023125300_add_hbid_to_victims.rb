class AddHbidToVictims < ActiveRecord::Migration
def change
  add_column :victims, :hb_id, :integer
end
end
