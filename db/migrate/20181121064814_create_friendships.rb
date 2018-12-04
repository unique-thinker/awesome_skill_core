# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user, foreign_key: true, null: false
      t.references :friend,
                   references:  :people,
                   foreign_key: {to_table: :people, name: :friendships_friend_id_fk, on_delete: :cascade},
                   index:       {name: :index_friendships_on_friend_id},
                   null:        false
      t.string :kind, null: false
      t.string :status, null: false

      t.timestamps
    end
    add_index :friendships, %i[user_id friend_id],
              name:   :index_friendships_on_user_id_and_friend_id,
              unique: true
  end
end
