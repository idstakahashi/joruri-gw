class CreateGwboardImageTables < ActiveRecord::Migration
  def change
    create_table "gwbbs_images", force: true do |t|
      t.integer  "unid"
      t.integer  "content_id"
      t.text     "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "recognized_at"
      t.datetime "published_at"
      t.datetime "latest_updated_at"
      t.integer  "parent_id"
      t.text     "parent_name"
      t.integer  "title_id"
      t.string   "content_type"
      t.text     "filename"
      t.text     "memo"
      t.integer  "size"
      t.integer  "width"
      t.integer  "height"
      t.integer  "db_file_id"
    end
    create_table "gwfaq_images" do |t|
      t.integer  "unid"
      t.integer  "content_id"
      t.text     "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "recognized_at"
      t.datetime "published_at"
      t.datetime "latest_updated_at"
      t.integer  "parent_id"
      t.text     "parent_name"
      t.integer  "title_id"
      t.string   "content_type"
      t.text     "filename"
      t.text     "memo"
      t.integer  "size"
      t.integer  "width"
      t.integer  "height"
      t.integer  "db_file_id"
    end
    create_table "gwqa_images" do |t|
      t.integer  "unid"
      t.integer  "content_id"
      t.text     "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "recognized_at"
      t.datetime "published_at"
      t.datetime "latest_updated_at"
      t.integer  "parent_id"
      t.text     "parent_name"
      t.integer  "title_id"
      t.string   "content_type"
      t.text     "filename"
      t.text     "memo"
      t.integer  "size"
      t.integer  "width"
      t.integer  "height"
      t.integer  "db_file_id"
    end
    create_table "doclibrary_images" do |t|
      t.integer  "unid"
      t.integer  "content_id"
      t.text     "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "recognized_at"
      t.datetime "published_at"
      t.datetime "latest_updated_at"
      t.integer  "parent_id"
      t.text     "parent_name"
      t.integer  "title_id"
      t.string   "content_type"
      t.text     "filename"
      t.text     "memo"
      t.integer  "size"
      t.integer  "width"
      t.integer  "height"
      t.integer  "db_file_id"
    end
    create_table "digitallibrary_images" do |t|
      t.integer  "unid"
      t.integer  "content_id"
      t.text     "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "recognized_at"
      t.datetime "published_at"
      t.datetime "latest_updated_at"
      t.integer  "parent_id"
      t.text     "parent_name"
      t.integer  "title_id"
      t.string   "content_type"
      t.text     "filename"
      t.text     "memo"
      t.integer  "size"
      t.integer  "width"
      t.integer  "height"
      t.integer  "db_file_id"
    end
  end
end
