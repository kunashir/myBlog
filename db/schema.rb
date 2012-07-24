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

ActiveRecord::Schema.define(:version => 20120530064728) do

  create_table "avtos", :force => true do |t|
    t.string   "model"
    t.string   "carcase"
    t.string   "statenumber"
    t.string   "trailnumber"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "storages", :force => true do |t|
    t.string   "city"
    t.string   "address"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.decimal  "volume"
    t.integer  "avto_id"
    t.integer  "driver_id"
    t.integer  "client_id"
    t.integer  "storage_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.boolean  "nmanager"
    t.integer  "company_id"
    t.boolean  "is_block",           :default => true
  end

end
