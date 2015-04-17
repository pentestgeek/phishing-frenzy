class AddLockableAttributesToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :failed_attempts, :integer
    add_column :admins, :locked_at, :datetime
    add_column :admins, :unlock_token, :string
  end
end
