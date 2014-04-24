class AddFieldsToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :browser, :string
    add_column :visits, :ip_address, :string
    add_column :visits, :extra, :string
  end
end
