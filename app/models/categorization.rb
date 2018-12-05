class Categorization < ApplicationRecord
  # Association
  belongs_to :category
  belongs_to :post

  # Validations
  validates_presence_of :category, :post
end
