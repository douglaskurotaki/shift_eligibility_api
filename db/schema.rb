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

ActiveRecord::Schema[7.1].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "Profession", ["CNA", "LVN", "RN"]

  create_table "Document", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.boolean "is_active", default: false, null: false
  end

  create_table "DocumentWorker", id: :serial, force: :cascade do |t|
    t.integer "worker_id", null: false
    t.integer "document_id", null: false
  end

  create_table "Facility", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.boolean "is_active", default: false, null: false
  end

  create_table "FacilityRequirement", id: :serial, force: :cascade do |t|
    t.integer "facility_id", null: false
    t.integer "document_id", null: false
  end

  create_table "Shift", id: :serial, force: :cascade do |t|
    t.datetime "start", precision: 3, null: false
    t.datetime "end", precision: 3, null: false
    t.enum "profession", null: false, enum_type: ""Profession""
    t.boolean "is_deleted", default: false, null: false
    t.integer "facility_id", null: false
    t.integer "worker_id"
  end

  create_table "Worker", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.boolean "is_active", default: false, null: false
    t.enum "profession", null: false, enum_type: ""Profession""
  end

  create_table "_prisma_migrations", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "checksum", limit: 64, null: false
    t.timestamptz "finished_at"
    t.string "migration_name", limit: 255, null: false
    t.text "logs"
    t.timestamptz "rolled_back_at"
    t.timestamptz "started_at", default: -> { "now()" }, null: false
    t.integer "applied_steps_count", default: 0, null: false
  end

  add_foreign_key "DocumentWorker", "Document", column: "document_id", name: "DocumentWorker_document_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "DocumentWorker", "Worker", column: "worker_id", name: "DocumentWorker_worker_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "FacilityRequirement", "Document", column: "document_id", name: "FacilityRequirement_document_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "FacilityRequirement", "Facility", column: "facility_id", name: "FacilityRequirement_facility_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Shift", "Facility", column: "facility_id", name: "Shift_facility_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Shift", "Worker", column: "worker_id", name: "Shift_worker_id_fkey", on_update: :cascade, on_delete: :nullify
end
