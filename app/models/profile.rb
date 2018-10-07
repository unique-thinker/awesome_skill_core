# frozen_string_literal: true

class Profile < ApplicationRecord
  # Association
  belongs_to :person

  # Validations
  validates :first_name, :last_name, length: {maximum: 32},
                                     format: {with: /\A[^;]+\z/, allow_blank: true}
end
