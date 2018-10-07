class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :profile_name, index: { unique: true }
      t.references :owner,
        references: :users,
        foreign_key: { to_table: :users },
        index: { unique: true }

      t.timestamps
    end
  end
end
