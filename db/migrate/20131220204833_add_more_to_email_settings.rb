class AddMoreToEmailSettings < ActiveRecord::Migration
  def change
    add_column :email_settings, :openssl_verify_mode, :string
    add_column :email_settings, :domain, :string
    add_column :email_settings, :authentication, :string
    add_column :email_settings, :enable_starttls_auto, :boolean
  end
end
