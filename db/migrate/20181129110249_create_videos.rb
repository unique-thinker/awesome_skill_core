class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.boolean :public, default: false, null: false
      t.string :guid, index: {unique: true}, null: false
      t.string :title
      t.text :description
      t.text :remote_video_path
      t.string :remote_video_name
      t.string :random_string
      t.string :duration
      t.integer :height
      t.integer :width
      t.string :processed_video
      t.integer :views_count
      t.references :author,
                   references:  :people,
                   foreign_key: {to_table: :people, name: :videos_author_id_fk, on_delete: :cascade},
                   index:       {name: :index_videos_on_person_id},
                   null:        false
      t.references :videoable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
