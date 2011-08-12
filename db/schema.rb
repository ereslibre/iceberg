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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110812101855) do

  create_table "command_sets", :force => true do |t|
    t.integer  "command_id"
    t.integer  "model_id"
    t.string   "command_line"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commands", :force => true do |t|
    t.string   "action"
    t.boolean  "arguments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "arguments_validation"
  end

  create_table "models", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "router_id"
    t.integer  "command_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routers", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.string   "password"
    t.string   "server"
    t.integer  "port"
    t.string   "router_username"
    t.string   "router_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "model_id"
    t.integer  "max_sessions"
  end

end
