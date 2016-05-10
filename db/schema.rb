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

ActiveRecord::Schema.define(version: 20160429111315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_rounds", force: :cascade do |t|
    t.integer "match_id"
    t.integer "team_id"
    t.integer "scored_goals"
    t.integer "missing_goals"
    t.integer "status"
    t.integer "round_number"
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "match_type"
    t.integer  "tour"
    t.integer  "winner_team_id"
    t.datetime "datetime"
    t.integer  "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "matches", ["tournament_id"], name: "index_matches_on_tournament_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id", using: :btree

  create_table "teams_users", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "tourn_type", null: false
    t.string   "place",      null: false
    t.datetime "datetime",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tournaments", ["name"], name: "index_tournaments_on_name", unique: true, using: :btree

  create_table "user_results", force: :cascade do |t|
    t.integer "user_id"
    t.integer "match_id"
    t.integer "team_id"
    t.integer "match_round_id"
    t.integer "scored_goals"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "email",                                    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin",               default: false
    t.integer  "rank",                   default: 1000
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "matches", "tournaments"
  add_foreign_key "teams", "tournaments"
end
