# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131219045315) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.string   "salt"
    t.boolean  "active",                 :default => true
    t.string   "notes"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "approved",               :default => false, :null => false
  end

  add_index "admins", ["approved"], :name => "index_admins_on_approved"
  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "attachments", :force => true do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "function",        :default => "website"
  end

  add_index "attachments", ["attachable_id"], :name => "index_attachments_on_attachable_id"

  create_table "baits", :force => true do |t|
    t.string   "to"
    t.string   "from"
    t.string   "status"
    t.string   "message"
    t.integer  "blast_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blasts", :force => true do |t|
    t.integer  "campaign_id"
    t.boolean  "test",              :default => false
    t.integer  "number_of_targets"
    t.integer  "emails_sent",       :default => 0
    t.string   "message",           :default => "Started"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "campaign_settings", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "fqdn"
    t.string   "phishing_url"
    t.string   "apache_directory_root"
    t.string   "apache_directory_index"
    t.boolean  "track_uniq_visitors",    :default => true
    t.boolean  "track_hits",             :default => true
    t.boolean  "iptable_restrictions",   :default => false
    t.boolean  "schedule_campaign",      :default => false
    t.boolean  "use_beef",               :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "campaign_settings", ["campaign_id"], :name => "index_campaign_settings_on_campaign_id"

  create_table "campaigns", :force => true do |t|
    t.integer  "template_id"
    t.string   "name"
    t.string   "description"
    t.boolean  "active",      :default => false
    t.integer  "scope"
    t.text     "emails"
    t.boolean  "email_sent",  :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "test_email"
  end

  add_index "campaigns", ["template_id"], :name => "index_campaigns_on_template_id"

  create_table "email_settings", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "to"
    t.string   "cc"
    t.string   "bcc"
    t.string   "from"
    t.string   "display_from"
    t.string   "subject"
    t.string   "phishing_url"
    t.string   "smtp_server"
    t.string   "smtp_server_out"
    t.integer  "smtp_port"
    t.string   "smtp_username"
    t.string   "smtp_password"
    t.integer  "emails_sent",     :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "email_settings", ["campaign_id"], :name => "index_email_settings_on_campaign_id"

  create_table "global_settings", :force => true do |t|
    t.string   "command_apache_restart"
    t.string   "path_apache_httpd"
    t.integer  "smtp_timeout",           :default => 5
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "command_apache_status"
    t.string   "command_apache_vhosts",  :default => "apache2ctl -S"
    t.boolean  "asynchronous",           :default => false
  end

  create_table "smtp_communications", :force => true do |t|
    t.string   "to"
    t.string   "from"
    t.string   "status"
    t.string   "string"
    t.integer  "campaign_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "smtp_communications", ["campaign_id"], :name => "index_smtp_communications_on_campaign_id"

  create_table "statistics", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "views"
    t.string   "downloads"
    t.string   "unique_visitors"
    t.string   "visitors_name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "templates", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "name"
    t.string   "description"
    t.string   "location"
    t.string   "notes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "templates", ["campaign_id"], :name => "index_templates_on_campaign_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "victims", :force => true do |t|
    t.string   "email_address"
    t.string   "campaign_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
