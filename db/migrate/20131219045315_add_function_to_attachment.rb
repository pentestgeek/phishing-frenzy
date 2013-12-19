class AddFunctionToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :function, :string, default: 'website'
  end
end
