# frozen_string_literal: true

class Person < ApplicationRecord
  # Validations
  validates :profile_name, presence: true, uniqueness: true

  # Association
  belongs_to :owner, class_name: "User", optional: true
end
