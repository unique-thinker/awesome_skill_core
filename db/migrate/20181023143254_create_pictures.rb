# frozen_string_literal: true

class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.boolean  :public, default: false, null: false
      t.string   :guid, index: {unique: true}, null: false
      t.string   :title
      t.text     :description
      t.text     :remote_image_path
      t.string   :remote_image_name
      t.string   :random_string
      t.integer  :height
      t.integer  :width
      t.string   :processed_image
      t.integer  :views_count
      t.references :author,
                   references:  :people,
                   foreign_key: {to_table: :people, name: :pictures_author_id_fk, on_delete: :cascade},
                   index:       {name: :index_pictures_on_person_id},
                   null:        false
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
