class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.boolean  :public, default: false, null: false
      t.string   :guid, index: { unique: true }, null: false
      t.text     :text
      t.text     :remote_image_path
      t.string   :remote_image_name
      t.string   :random_string
      t.string   :processed_image
      t.integer  :height
      t.integer  :width
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
