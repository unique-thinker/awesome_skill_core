# frozen_string_literal: true

class Category < ApplicationRecord
  self.inheritance_column = nil

  include Fields::Guid

  # ENUM
  enum type: {video: 'video', picture: 'picture'}

  # Association
  has_ancestry
  has_many :categorizations
  has_many :posts, through: :categorizations

  # Validations
  validates :type, inclusion: {in: types.keys}
  validates :name, :guid, :type, presence: true
  validates :guid, uniqueness: true
end
