class ChangeHbColumnName  < ActiveRecord::Migration
  def change
    rename_column :hooked_browsers, :type, :btype
    rename_column :hooked_browsers, :version, :bversion
  end
end
