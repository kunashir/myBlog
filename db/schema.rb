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

ActiveRecord::Schema.define(version: 20151007081122) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.text     "body"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "namespace",     limit: 255
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"

  create_table "areas", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  create_table "avtos", force: :cascade do |t|
    t.string   "model",       limit: 255
    t.string   "carcase",     limit: 255
    t.string   "statenumber", limit: 255
    t.string   "trailnumber", limit: 255
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname",   limit: 255
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                 default: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["id"], name: "index_clients_on_id"

  create_table "companies", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "inn"
    t.boolean  "is_freighter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drivers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "passport",   limit: 255
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "transportation_id"
    t.integer  "user_id"
    t.string   "attr",              limit: 255
    t.string   "oldvalue",          limit: 255
    t.string   "action",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "lots", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "description"
    t.integer  "step"
    t.integer  "start_summa"
    t.integer  "current_summa"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "for_selling"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "content"
    t.date     "publish_date"
    t.date     "end_date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "area_id"
    t.integer  "city_id"
    t.string   "carcase",    limit: 255
    t.integer  "summa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key"

  create_table "storages", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.string   "name",       limit: 255
  end

  add_index "storages", ["id"], name: "index_storages_on_id"

  create_table "transportations", force: :cascade do |t|
    t.integer  "num"
    t.date     "date"
    t.time     "time"
    t.string   "storage_source",    limit: 255
    t.string   "storage_dist",      limit: 255
    t.string   "comment",           limit: 255
    t.string   "type_transp",       limit: 255
    t.decimal  "weight"
    t.string   "carcase",           limit: 255
    t.integer  "start_sum"
    t.integer  "cur_sum"
    t.integer  "step"
    t.integer  "manager_id"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "volume",            limit: 255
    t.integer  "avto_id"
    t.integer  "driver_id"
    t.integer  "client_id"
    t.integer  "storage_id"
    t.boolean  "specprice"
    t.boolean  "request_abort",                 default: false
    t.integer  "abort_company"
    t.integer  "area_id"
    t.integer  "rate_id"
    t.datetime "time_last_action"
    t.boolean  "complex_direction"
    t.integer  "extra_pay",                     default: 0
    t.integer  "city_id"
    t.datetime "last_bid_at"
    t.datetime "unloading"
  end

  add_index "transportations", ["date"], name: "index_transportations_on_date"
  add_index "transportations", ["id"], name: "index_transportations_on_id"

  create_table "user_msgs", force: :cascade do |t|
    t.boolean  "active",     default: true
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.boolean  "manager"
    t.integer  "company_id"
    t.boolean  "is_block",                        default: true
    t.boolean  "be_notified",                     default: true
    t.boolean  "show_reg",                        default: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token"

end
