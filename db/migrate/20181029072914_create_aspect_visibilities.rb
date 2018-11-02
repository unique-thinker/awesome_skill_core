# frozen_string_literal: true

class CreateAspectVisibilities < ActiveRecord::Migration[5.2]
  def change
    create_table :aspect_visibilities do |t|
      t.references :aspect,
                   foreign_key: {on_delete: :cascade},
                   index:       {name: :index_aspect_visibilities_on_aspect_id}
      t.references :shareable,
                   polymorphic: true,
                   index:       {name: :index_aspect_visibilities_on_shareable_id_and_shareable_type},
                   length:      {shareable_type: 190}

      t.timestamps
    end
    add_index :aspect_visibilities, %i[aspect_id shareable_id shareable_type],
              unique: true, name: :shareable_and_aspect_id, length: {shareable_type: 189}
  end
end
