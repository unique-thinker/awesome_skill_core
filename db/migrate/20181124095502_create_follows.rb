class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :following,
                   references:  :people,
                   foreign_key: {to_table: :people},
                   index:       {name: :index_follows_on_following_id},
                   null:        false
      t.references :follower,
                   references:  :people,
                   foreign_key: {to_table: :people},
                   index:       {name: :index_follows_on_follower_id},
                   null:        false
      t.timestamps
    end
    add_index :follows, %i[following_id follower_id],
              name:   :index_follows_on_following_id_and_follower_id,
              unique: true
  end
end
