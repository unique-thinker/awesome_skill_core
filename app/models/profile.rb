# frozen_string_literal: true

class Profile < ApplicationRecord
  include CountriesWithStates

  # Association
  belongs_to :person

  # Validations
  validates :first_name, :last_name, length: {maximum: 32},
                                     format: {with: /\A[^;]+\z/, allow_blank: true}
  validates :gender, inclusion: { in: %W(M F), message: 'must be Male or Female' }, allow_blank: true
end
