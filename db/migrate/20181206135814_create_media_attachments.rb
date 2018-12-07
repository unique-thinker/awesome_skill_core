class CreateMediaAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :media_attachments do |t|
      t.boolean :public, default: false, null: false
      t.string :kind, null: false
      t.string :guid, index: {unique: true}, null: false
      t.string :title
      t.text :description
      t.text :remote_file_path
      t.string :remote_file_name
      t.string :random_string
      t.string :file
      t.integer :views_count
      t.string :content_type
      t.integer :size
      t.json :file_meta
      t.references :attachable, polymorphic: true
      t.references :author,
                   references:  :people,
                   foreign_key: {to_table: :people, name: :media_attachments_author_id_fk, on_delete: :cascade},
                   index:       {name: :index_media_attachments_on_person_id},
                   null:        false

      t.timestamps
    end
  end
end
