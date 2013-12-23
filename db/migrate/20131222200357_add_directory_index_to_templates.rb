class AddDirectoryIndexToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :directory_index, :string
  end
end
