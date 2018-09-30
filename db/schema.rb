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

ActiveRecord::Schema.define(version: 20180927115034) do

  create_table "child_photos", force: :cascade do |t|
    t.integer "child_id"
    t.string "description"
    t.string "key"
    t.integer "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "children", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "size"
    t.string "age_range"
    t.string "gender"
    t.text "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosting_sessions", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.date "begins"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_spots", force: :cascade do |t|
    t.integer "child_id"
    t.integer "hosting_session_id"
    t.integer "spot_status_id"
    t.integer "scholarship"
    t.integer "row_order"
    t.text "public_notes"
    t.text "private_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spot_statuses", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
