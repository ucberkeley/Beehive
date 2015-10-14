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

ActiveRecord::Schema.define(version: 20151014025842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applics", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.integer  "resume_id"
    t.integer  "transcript_id"
    t.string   "status",        limit: 255, default: "undecided"
    t.boolean  "applied"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_jobs", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "job_id"
  end

  create_table "coursereqs", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.text     "desc"
  end

  create_table "curations", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "org_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "curations", ["job_id"], name: "index_curations_on_job_id", using: :btree
  add_index "curations", ["org_id"], name: "index_curations_on_org_id", using: :btree
  add_index "curations", ["user_id"], name: "index_curations_on_user_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.text     "name",                         null: false
    t.datetime "created_at", default: "now()"
    t.datetime "updated_at", default: "now()"
  end

  add_index "departments", ["name"], name: "departments_name_key", unique: true, using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "document_type"
    t.integer  "size"
    t.string   "content_type",  limit: 255
    t.string   "filename",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", force: :cascade do |t|
    t.string   "grade",      limit: 255
    t.string   "semester",   limit: 255
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties", force: :cascade do |t|
    t.string   "name",          limit: 255,                   null: false
    t.string   "email",         limit: 255
    t.datetime "created_at",                default: "now()"
    t.datetime "updated_at",                default: "now()"
    t.integer  "department_id"
    t.string   "calnetuid"
  end

  add_index "faculties", ["calnetuid"], name: "faculties_calnetuid_key", unique: true, using: :btree
  add_index "faculties", ["name"], name: "faculties_name_key", unique: true, using: :btree

  create_table "interests", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",               limit: 255
    t.text     "desc"
    t.integer  "category_id"
    t.integer  "num_positions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.integer  "activation_code"
    t.boolean  "delta",                           default: true, null: false
    t.datetime "earliest_start_date"
    t.datetime "latest_start_date"
    t.datetime "end_date"
    t.integer  "compensation",                    default: 0
    t.integer  "status",                          default: 0
    t.integer  "primary_contact_id"
    t.integer  "project_type"
  end

  create_table "majors", force: :cascade do |t|
    t.string "name"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "org_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["org_id"], name: "index_memberships_on_org_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "orgs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "desc"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "abbr",       limit: 255
  end

  create_table "owns", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proficiencies", force: :cascade do |t|
    t.integer  "proglang_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proglangreqs", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "proglang_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proglangs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sponsorships", force: :cascade do |t|
    t.integer  "faculty_id"
    t.integer  "job_id"
    t.datetime "created_at", default: "now()"
    t.datetime "updated_at", default: "now()"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "temp", force: :cascade do |t|
    t.string "name",      limit: 255, null: false
    t.string "email",     limit: 255, null: false
    t.string "calnetuid", limit: 255, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "login",               limit: 255
    t.string   "email",               limit: 255
    t.string   "persistence_token",   limit: 255,             null: false
    t.string   "single_access_token", limit: 255,             null: false
    t.string   "perishable_token",    limit: 255,             null: false
    t.integer  "login_count",                     default: 0, null: false
    t.integer  "failed_login_count",              default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 255
    t.string   "last_login_ip",       limit: 255
    t.integer  "user_type",                       default: 0, null: false
    t.integer  "units"
    t.integer  "free_hours"
    t.text     "research_blurb"
    t.string   "experience",          limit: 255
    t.boolean  "summer"
    t.string   "url",                 limit: 255
    t.integer  "year"
    t.integer  "class_of"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

  create_table "watches", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "faculties", "departments", name: "faculties_department_id_fkey"
  add_foreign_key "sponsorships", "faculties", name: "sponsorships_faculty_id_fkey"
  add_foreign_key "sponsorships", "jobs", name: "sponsorships_job_id_fkey"
end
