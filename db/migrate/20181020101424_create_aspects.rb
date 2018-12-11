# frozen_string_literal: true

class CreateAspects < ActiveRecord::Migration[5.2]
  def change
    create_table :aspects do |t|
      t.string     :name, null: false
      t.integer    :order_id
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps
    end
    add_index :aspects, %i[user_id name], unique: true
  end
end
