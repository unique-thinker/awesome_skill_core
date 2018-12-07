# frozen_string_literal: true

class Categorization < ApplicationRecord
  # Association
  belongs_to :category
  belongs_to :post

  # Validations
  validates :category, :post, presence: true
end
