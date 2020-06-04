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

ActiveRecord::Schema.define(version: 20160424174939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rensous", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "keyword",                       null: false
    t.string   "old_keyword",                   null: false
    t.integer  "favorite",       default: 0,    null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "old_identifier",                null: false
    t.integer  "app_id",         default: 1,    null: false
    t.string   "lang",           default: "ja", null: false
  end

  add_index "rensous", ["app_id"], name: "index_rensous_on_app_id", using: :btree
  add_index "rensous", ["old_identifier"], name: "index_rensous_on_old_identifier", unique: true, using: :btree
  add_index "rensous", ["user_id"], name: "index_rensous_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "device_type",                    null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "registration_token"
    t.integer  "app_id",             default: 1, null: false
  end

  add_index "users", ["app_id"], name: "index_users_on_app_id", using: :btree

  add_foreign_key "rensous", "apps"
  add_foreign_key "rensous", "users"
  add_foreign_key "users", "apps"
end
