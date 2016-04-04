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

ActiveRecord::Schema.define(version: 20160404184819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "elevators", force: true do |t|
    t.string "building_name", null: false
    t.string "address",       null: false
    t.string "city",          null: false
    t.string "zipcode",       null: false
    t.string "state",         null: false
  end

  add_index "elevators", ["building_name"], name: "index_elevators_on_building_name", unique: true, using: :btree

  create_table "reviews", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "elevator_id", null: false
    t.integer "rating",      null: false
    t.text    "body"
  end

  create_table "users", force: true do |t|
    t.string "username"
    t.string "email",    null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
