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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170817013131) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255
    t.string   "password",               limit: 255
    t.string   "salt",                   limit: 255
    t.boolean  "active",                             default: true
    t.string   "notes",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.boolean  "approved",                           default: false, null: false
  end

  add_index "admins", ["approved"], name: "index_admins_on_approved", using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "file",            limit: 255
    t.integer  "attachable_id",   limit: 4
    t.string   "attachable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "function",        limit: 255, default: "website"
  end

  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree

  create_table "baits", force: :cascade do |t|
    t.string   "to",         limit: 255
    t.string   "from",       limit: 255
    t.string   "status",     limit: 255
    t.string   "message",    limit: 255
    t.integer  "blast_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blasts", force: :cascade do |t|
    t.integer  "campaign_id",       limit: 4
    t.boolean  "test",                          default: false
    t.integer  "number_of_targets", limit: 4
    t.integer  "emails_sent",       limit: 4,   default: 0
    t.string   "message",           limit: 255, default: "Started  "
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "baits_count",       limit: 4,   default: 0
  end

  create_table "campaign_settings", force: :cascade do |t|
    t.integer  "campaign_id",            limit: 4
    t.string   "fqdn",                   limit: 255
    t.string   "phishing_url",           limit: 255
    t.string   "apache_directory_root",  limit: 255
    t.string   "apache_directory_index", limit: 255
    t.boolean  "track_uniq_visitors",                default: true
    t.boolean  "track_hits",                         default: true
    t.boolean  "iptable_restrictions",               default: false
    t.boolean  "schedule_campaign",                  default: false
    t.boolean  "use_beef",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "smtp_delay",             limit: 4,   default: 0
    t.string   "beef_url",               limit: 255
    t.boolean  "ssl"
    t.boolean  "require_uid",                        default: true
    t.boolean  "password_storage",                   default: true
  end

  add_index "campaign_settings", ["campaign_id"], name: "index_campaign_settings_on_campaign_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.integer  "template_id", limit: 4
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.boolean  "active",                    default: false
    t.integer  "scope",       limit: 4
    t.text     "emails",      limit: 65535
    t.boolean  "email_sent",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "test_email",  limit: 255
    t.integer  "admin_id",    limit: 4
  end

  add_index "campaigns", ["admin_id"], name: "index_campaigns_on_admin_id", using: :btree
  add_index "campaigns", ["template_id"], name: "index_campaigns_on_template_id", using: :btree

  create_table "clones", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "status",     limit: 255
    t.text     "url",        limit: 65535
    t.text     "page",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_searches", force: :cascade do |t|
    t.string   "domain",             limit: 255
    t.integer  "crawls",             limit: 4
    t.integer  "harvested_email_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_searches", ["harvested_email_id"], name: "index_email_searches_on_harvested_email_id", using: :btree

  create_table "email_settings", force: :cascade do |t|
    t.integer  "campaign_id",          limit: 4
    t.string   "to",                   limit: 255
    t.string   "cc",                   limit: 255
    t.string   "bcc",                  limit: 255
    t.string   "from",                 limit: 255
    t.string   "display_from",         limit: 255
    t.string   "subject",              limit: 255
    t.string   "phishing_url",         limit: 255
    t.string   "smtp_server",          limit: 255
    t.string   "smtp_server_out",      limit: 255
    t.integer  "smtp_port",            limit: 4
    t.string   "smtp_username",        limit: 255
    t.string   "smtp_password",        limit: 255
    t.integer  "emails_sent",          limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "openssl_verify_mode",  limit: 255
    t.string   "domain",               limit: 255
    t.string   "authentication",       limit: 255
    t.boolean  "enable_starttls_auto"
    t.string   "reply_to",             limit: 255
  end

  add_index "email_settings", ["campaign_id"], name: "index_email_settings_on_campaign_id", using: :btree

  create_table "global_settings", force: :cascade do |t|
    t.string   "command_apache_restart", limit: 255
    t.integer  "smtp_timeout",           limit: 4,   default: 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "command_apache_status",  limit: 255
    t.string   "command_apache_vhosts",  limit: 255, default: "apache2ctl -S"
    t.boolean  "asynchronous",                       default: true
    t.string   "bing_api",               limit: 255
    t.string   "beef_url",               limit: 255
    t.string   "sites_enabled_path",     limit: 255, default: "/etc/apache2/sites-enabled"
    t.integer  "reports_refresh",        limit: 4,   default: 15
    t.string   "site_url",               limit: 255, default: "https://phishingfrenzy.local"
  end

  create_table "harvested_emails", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "group",           limit: 255
    t.text     "url",             limit: 65535
    t.integer  "email_search_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original",        limit: 255
  end

  add_index "harvested_emails", ["email_search_id"], name: "index_harvested_emails_on_email_search_id", using: :btree

  create_table "smtp_communications", force: :cascade do |t|
    t.string   "to",          limit: 255
    t.string   "from",        limit: 255
    t.string   "status",      limit: 255
    t.string   "string",      limit: 255
    t.integer  "campaign_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smtp_communications", ["campaign_id"], name: "index_smtp_communications_on_campaign_id", using: :btree

  create_table "ssls", force: :cascade do |t|
    t.string   "filename",    limit: 255
    t.string   "function",    limit: 255
    t.integer  "campaign_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ssls", ["campaign_id"], name: "index_ssls_on_campaign_id", using: :btree

  create_table "statistics", force: :cascade do |t|
    t.integer  "campaign_id",     limit: 4
    t.string   "views",           limit: 255
    t.string   "downloads",       limit: 255
    t.string   "unique_visitors", limit: 255
    t.string   "visitors_name",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: :cascade do |t|
    t.integer  "campaign_id",     limit: 4
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.string   "location",        limit: 255
    t.string   "notes",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "directory_index", limit: 255
    t.integer  "admin_id",        limit: 4
  end

  add_index "templates", ["admin_id"], name: "index_templates_on_admin_id", using: :btree
  add_index "templates", ["campaign_id"], name: "index_templates_on_campaign_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "victims", force: :cascade do |t|
    t.string   "email_address", limit: 255
    t.integer  "campaign_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",           limit: 255
    t.string   "firstname",     limit: 255
    t.string   "lastname",      limit: 255
    t.boolean  "archive",                   default: false
    t.boolean  "sent",                      default: false
  end

  create_table "visits", force: :cascade do |t|
    t.integer  "victim_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "browser",    limit: 255
    t.string   "ip_address", limit: 255
    t.string   "extra",      limit: 255
  end

  add_index "visits", ["victim_id"], name: "index_visits_on_victim_id", using: :btree

  add_foreign_key "campaigns", "admins"
  add_foreign_key "templates", "admins"
end
