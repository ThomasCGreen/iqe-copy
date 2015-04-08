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

ActiveRecord::Schema.define(version: 20140719193347) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "innovations", force: true do |t|
    t.string   "style"
    t.string   "innovation_type"
    t.integer  "order"
    t.text     "innovation_words"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_innovations_id"
    t.integer  "tag_value"
  end

  add_index "innovations", ["version_innovations_id"], name: "index_innovations_on_version_innovations_id"

  create_table "qtests", force: true do |t|
    t.string   "license_key"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "state"
    t.string   "gender"
    t.string   "age_range"
    t.string   "department"
    t.string   "level"
    t.string   "degree"
    t.integer  "years_in_workforce"
    t.string   "innovation_style"
    t.string   "driving_strength_1"
    t.string   "driving_strength_2"
    t.string   "latent_strength"
    t.boolean  "unused"
    t.boolean  "license_key_sent"
    t.integer  "question_finished"
    t.boolean  "results_sent_to_infusionsoft"
    t.integer  "major_version"
    t.integer  "minor_version"
    t.boolean  "free_test"
    t.string   "coach_first_name"
    t.string   "coach_last_name"
    t.string   "coach_email"
    t.string   "company"
    t.boolean  "send_to_client"
    t.integer  "multi_license"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_answers_id"
    t.integer  "trigger_scores_id"
    t.datetime "completed_time"
  end

  add_index "qtests", ["question_answers_id"], name: "index_qtests_on_question_answers_id"
  add_index "qtests", ["trigger_scores_id"], name: "index_qtests_on_trigger_scores_id"

  create_table "question_answers", force: true do |t|
    t.integer  "qtest_id"
    t.integer  "question_seq"
    t.integer  "question_number"
    t.integer  "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer  "question_number"
    t.string   "question_words"
    t.boolean  "inverted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_questions_id"
  end

  add_index "questions", ["version_questions_id"], name: "index_questions_on_version_questions_id"

  create_table "trigger_scores", force: true do |t|
    t.integer  "qtest_id"
    t.string   "trigger_name"
    t.decimal  "score",        precision: 8, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "triggers", force: true do |t|
    t.string   "trigger_name"
    t.string   "trigger_type"
    t.integer  "order"
    t.text     "trigger_words"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_triggers_id"
  end

  add_index "triggers", ["version_triggers_id"], name: "index_triggers_on_version_triggers_id"

  create_table "version_innovations", force: true do |t|
    t.integer  "version_id"
    t.integer  "innovation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "version_questions", force: true do |t|
    t.integer  "version_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "version_triggers", force: true do |t|
    t.integer  "version_id"
    t.integer  "trigger_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.integer  "major_version"
    t.integer  "minor_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_innovations_id"
    t.integer  "version_triggers_id"
    t.integer  "version_questions_id"
    t.integer  "weights_id"
  end

  add_index "versions", ["version_innovations_id"], name: "index_versions_on_version_innovations_id"
  add_index "versions", ["version_questions_id"], name: "index_versions_on_version_questions_id"
  add_index "versions", ["version_triggers_id"], name: "index_versions_on_version_triggers_id"
  add_index "versions", ["weights_id"], name: "index_versions_on_weights_id"

  create_table "weights", force: true do |t|
    t.integer  "version_id"
    t.integer  "question_number"
    t.string   "trigger_name"
    t.integer  "normal_weight"
    t.integer  "double_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
