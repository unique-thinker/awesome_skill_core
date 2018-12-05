class Categorization < ApplicationRecord
  # Association
  belongs_to :category, inverse_of: :categorizations
  belongs_to :post, inverse_of: :categorizations

  # Validations
  validates_presence_of :category, :post
end
