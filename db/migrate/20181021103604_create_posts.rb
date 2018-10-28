# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.boolean     :public, default: false, null: false
      t.string      :guid, index: {unique: true}, null: false
      t.text        :text
      t.references  :postable, polymorphic: true, index: true

      t.timestamps
    end
    add_index :posts, %i[id postable_type created_at]
  end
end
