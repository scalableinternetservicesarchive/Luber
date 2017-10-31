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

ActiveRecord::Schema.define(version: 20171021221841) do

  create_table "cars", force: :cascade do |t|
    t.integer "user_id"
    t.string "plate_num"
    t.string "model"
    t.string "color"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rental_posts", force: :cascade do |t|
    t.integer "car_id"
    t.integer "owner_id"
    t.integer "renter_id"
    t.string "start_location"
    t.string "end_location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "car_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_taggings_on_car_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "ssn"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
