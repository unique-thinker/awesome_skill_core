# frozen_string_literal: true

class CreateCategorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :categorizations do |t|
      t.references :category, foreign_key: true
      t.references :post, foreign_key: true
    end
    add_index :categorizations, %i[category_id post_id],
              name: :index_categorizations_on_category_id_and_post_id
  end
end
