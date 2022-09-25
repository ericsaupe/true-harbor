# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_25_034444) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "families", force: :cascade do |t|
    t.string "name", null: false
    t.string "address_1", null: false
    t.string "address_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "region", null: false
    t.date "license_date"
    t.integer "status", default: 0, null: false
    t.integer "race"
    t.integer "religion"
    t.integer "family_interest", default: 0, null: false
    t.boolean "other_children_in_home", default: false
    t.integer "spots_available", default: 0
    t.boolean "icwa", default: false
    t.boolean "dogs", default: false
    t.boolean "cats", default: false
    t.boolean "other_animals", default: false
    t.boolean "available_visit_transportation", default: false
    t.boolean "available_school_transportation", default: false
    t.boolean "available_counselor_transportation", default: false
    t.boolean "available_multiple_appointments_per_week", default: false
    t.text "recreational_activities"
    t.text "skills"
    t.text "experience_with_care"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_contacted_at"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "search_id", null: false
    t.bigint "family_id", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_results_on_family_id"
    t.index ["search_id"], name: "index_results_on_search_id"
  end

  create_table "searches", force: :cascade do |t|
    t.string "name", null: false
    t.text "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "results", "families"
  add_foreign_key "results", "searches"
end
