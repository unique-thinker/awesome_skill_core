# frozen_string_literal: true

class Profile < ApplicationRecord
  include Fields::Guid
  include CountriesWithStates

  # Association
  belongs_to :person
  has_one :attachment, as: :attachable, class_name: 'MediaAttachment', dependent: :destroy

  # Validations
  validates :first_name, :last_name, length: {maximum: 32},
                                     format: {with: /\A[^;]+\z/, allow_blank: true}
  validates :gender, inclusion: {in: %w[M F], message: 'must be Male or Female'}, allow_blank: true
end
