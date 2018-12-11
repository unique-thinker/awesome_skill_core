# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :profile_name, index: {unique: true}, null: false
      t.string :guid, index: {unique: true}, null: false
      t.references :owner,
                   references:  :users,
                   foreign_key: {to_table: :users},
                   index:       {unique: true},
                   null:        false

      t.timestamps
    end
  end
end
