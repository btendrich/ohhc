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

ActiveRecord::Schema.define(version: 20180930231216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "child_notes", force: :cascade do |t|
    t.integer "child_id"
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "children", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "identifier"
    t.string "country"
    t.date "birthday"
    t.string "gender"
    t.text "description"
    t.text "sibling_notes"
    t.string "orphanage"
    t.text "legal_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "families", force: :cascade do |t|
    t.string "first_names"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosting_session_spot_children", force: :cascade do |t|
    t.integer "child_id"
    t.integer "hosting_session_spot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosting_session_spots", force: :cascade do |t|
    t.integer "status_id"
    t.integer "hosting_session_id"
    t.text "description"
    t.integer "scholarship"
    t.integer "family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosting_sessions", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "siblings", force: :cascade do |t|
    t.integer "child_id"
    t.integer "sibling_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spot_statuses", force: :cascade do |t|
    t.string "name"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
