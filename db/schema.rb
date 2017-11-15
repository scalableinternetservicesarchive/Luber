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

ActiveRecord::Schema.define(version: 20171115174054) do

  create_table "cars", force: :cascade do |t|
    t.integer "user_id"
    t.string "make"
    t.string "model"
    t.integer "year"
    t.string "color"
    t.string "plate_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rentals", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "renter_id"
    t.integer "car_id"
    t.string "start_location"
    t.string "end_location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "price"
    t.integer "status", default: 0
    t.string "terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "car_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id", "tag_id"], name: "index_taggings_on_car_id_and_tag_id", unique: true
    t.index ["car_id"], name: "index_taggings_on_car_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "state"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin"
    t.datetime "logged_in_at"
    t.datetime "logged_out_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
