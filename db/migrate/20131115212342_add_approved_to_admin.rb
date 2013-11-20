class AddApprovedToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :approved, :boolean, :default => false, :null => false
    add_index  :admins, :approved
  end
end
