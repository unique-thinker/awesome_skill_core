# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :guid, index: {unique: true}, null: false
      t.string :name, null: false
      t.string :ancestry, index: true
      t.string :kind, null: false

      t.timestamps
    end
  end
end
