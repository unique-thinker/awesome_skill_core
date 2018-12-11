# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :text, null: false
      t.string :guid,
               index: {name: :index_comments_on_guid, length: {guid: 191}, unique: true},
               null:  false
      t.references :author,
                   references:  :people,
                   foreign_key: {to_table: :people, name: :comments_author_id_fk, on_delete: :cascade},
                   index:       {name: :index_comments_on_person_id},
                   null:        false
      t.references :commentable, polymorphic: true,
                                 index:       {name: :index_comments_on_commentable_id_and_commentable_type},
                                 null:        false

      t.timestamps
    end
  end
end
