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

ActiveRecord::Schema.define(version: 20180826022438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lecture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "department_id"
    t.integer "category"
    t.integer "target_grade"
    t.integer "total_unit"
    t.integer "lecture_unit"
    t.integer "lab_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "slug"
    t.index ["slug"], name: "index_courses_on_slug", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments_professors", id: false, force: :cascade do |t|
    t.bigint "department_id"
    t.bigint "professor_id"
    t.index ["department_id"], name: "index_departments_professors_on_department_id"
    t.index ["professor_id"], name: "index_departments_professors_on_professor_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lecture_id"
    t.text "comment"
    t.integer "score", default: 0
    t.integer "easiness", default: 0
    t.integer "grading", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "semester_id"
    t.integer "upvotes_count", default: 0
    t.integer "downvotes_count", default: 0
    t.index ["lecture_id"], name: "index_evaluations_on_lecture_id"
    t.index ["user_id"], name: "index_evaluations_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "lecture_sessions", force: :cascade do |t|
    t.integer "target_grade"
    t.string "schedule"
    t.string "classroom"
    t.integer "capacity"
    t.bigint "lecture_id"
    t.bigint "semester_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quota", default: 0
    t.string "class_time"
    t.string "location"
    t.string "remark"
    t.string "lang"
    t.string "status"
    t.integer "department_id"
    t.index ["lecture_id"], name: "index_lecture_sessions_on_lecture_id"
    t.index ["semester_id"], name: "index_lecture_sessions_on_semester_id"
  end

  create_table "lectures", force: :cascade do |t|
    t.integer "course_id"
    t.float "score", default: 0.0
    t.float "easiness", default: 0.0
    t.float "grading", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "professor_id"
    t.string "slug"
    t.integer "evaluations_count", default: 0
    t.string "code"
    t.integer "impressions_count", default: 0
    t.index ["course_id"], name: "index_lectures_on_course_id"
    t.index ["slug"], name: "index_lectures_on_slug", unique: true
  end

  create_table "professors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_professors_on_slug", unique: true
  end

  create_table "semesters", force: :cascade do |t|
    t.integer "year"
    t.integer "season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "username", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.datetime "last_signed_out_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "reset_token"
    t.datetime "reset_sent_at"
    t.integer "department_id"
    t.string "legacy_password_salt"
    t.string "legacy_password_hash"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_token"], name: "index_users_on_reset_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "type"
    t.integer "votable_id"
    t.string "votable_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "votable_id", "votable_type"], name: "index_votes_on_user_id_and_votable_id_and_votable_type", unique: true
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
  end

end
