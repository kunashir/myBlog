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

ActiveRecord::Schema.define(:version => 20140327103307) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  create_table "avtos", :force => true do |t|
    t.string   "model"
    t.string   "carcase"
    t.string   "statenumber"
    t.string   "trailnumber"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["id"], :name => "index_clients_on_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "inn"
    t.boolean  "is_freighter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drivers", :force => true do |t|
    t.string   "name"
    t.string   "passport"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "transportation_id"
    t.integer  "user_id"
    t.string   "attr"
    t.string   "oldvalue"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "rates", :force => true do |t|
    t.integer  "area_id"
    t.integer  "city_id"
    t.string   "carcase"
    t.integer  "summa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "storages", :force => true do |t|
    t.string   "address"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.string   "name"
  end

  add_index "storages", ["id"], :name => "index_storages_on_id"

  create_table "transportations", :force => true do |t|
    t.integer  "num"
    t.date     "date"
    t.time     "time"
    t.string   "storage_source"
    t.string   "storage_dist"
    t.string   "comment"
    t.string   "type_transp"
    t.decimal  "weight"
    t.string   "carcase"
    t.integer  "start_sum"
    t.integer  "cur_sum"
    t.integer  "step"
    t.integer  "user_id"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "volume"
    t.integer  "avto_id"
    t.integer  "driver_id"
    t.integer  "client_id"
    t.integer  "storage_id"
    t.boolean  "specprice"
    t.boolean  "request_abort",     :default => false
    t.integer  "abort_company"
    t.integer  "area_id"
    t.integer  "rate_id"
    t.datetime "time_last_action"
    t.boolean  "complex_direction"
    t.integer  "extra_pay",         :default => 0
    t.integer  "city_id"
  end

  add_index "transportations", ["id"], :name => "index_transportations_on_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.boolean  "nmanager"
    t.integer  "company_id"
    t.boolean  "is_block",           :default => true
    t.boolean  "be_notified",        :default => true
    t.boolean  "show_reg",           :default => true
    t.integer  "login_count",        :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
