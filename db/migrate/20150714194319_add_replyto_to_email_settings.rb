class AddReplytoToEmailSettings < ActiveRecord::Migration
  def change
    add_column :email_settings, :reply_to, :string
  end
end
