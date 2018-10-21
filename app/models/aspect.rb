# frozen_string_literal: true

class Aspect < ApplicationRecord
  # Association
  belongs_to :user

  # Validations
  validates :name, presence: true, length: {maximum: 20}, null: false
  validates :name, uniqueness: {scope: :user_id, case_sensitive: false}
  validates_associated :user

  # before_validation do
  #   binding.pry
  #   name.strip!
  # end
end
