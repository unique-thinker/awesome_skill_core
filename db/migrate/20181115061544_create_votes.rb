# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.boolean :positive
      t.string :guid, index: {unique: true, name: :index_votes_on_guid}
      t.string :type
      t.references :author,
                   references:  :people,
                   foreign_key: {to_table: :people, name: :votes_author_id_fk, on_delete: :cascade},
                   index:       {name: :index_votes_on_person_id},
                   null:        false
      t.references :target, polymorphic: true

      t.timestamps
    end
    add_index :votes,
              %i[target_id author_id target_type],
              name:   :index_votes_on_target_id_and_author_id_and_target_type,
              unique: true
    add_index :votes, :target_id, name: :index_votes_on_post_id
  end
end
