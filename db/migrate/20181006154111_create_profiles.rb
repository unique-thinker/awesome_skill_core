# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :guid, index: {unique: true}, null: false
      t.string   :first_name, index: true
      t.string   :last_name,  index: true
      t.date     :birthday
      t.string   :gender
      t.string   :status
      t.text     :bio
      t.string   :professions
      t.string   :company
      t.string   :current_place
      t.string   :native_place
      t.string   :state
      t.string   :country
      t.references :person, index: {unique: true, name: :index_profiles_on_person_id}, foreign_key: {on_delete: :cascade}, null: false

      t.timestamps
    end
  end
end
