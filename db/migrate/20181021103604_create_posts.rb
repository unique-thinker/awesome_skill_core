# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.boolean     :public, default: false, null: false
      t.string      :guid, index: {unique: true}, null: false
      t.text        :text
      t.string      :type, limit: 40, null: false
      t.references  :author,
                    references:  :people,
                    foreign_key: {to_table: :people},
                    index:       true,
                    null:        false

      t.timestamps
    end
    add_index :posts, %i[id type]
    add_index :posts, %i[id type created_at]
  end
end
