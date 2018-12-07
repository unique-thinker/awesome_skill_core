# frozen_string_literal: true

class Category < ApplicationRecord
  include Fields::Guid

  # ENUM
  enum kind: {video: 'video', picture: 'picture'}

  # Association
  has_ancestry
  has_many :categorizations
  has_many :posts, through: :categorizations

  # Validations
  validates :kind, inclusion: {in: kinds.keys}
  validates :name, :guid, :kind, presence: true
  validates :guid, uniqueness: true
end
