class Category < ApplicationRecord
  include Fields::Guid

  # ENUM
  enum kind: {video: 'video', picture: 'picture'}

  # Association
  has_ancestry
  has_many :categorizations, inverse_of:  :category
  has_many :posts, through: :categorizations

  # Validations
  validates :kind, inclusion: { in: kinds.keys}
  validates_presence_of :name, :guid, :kind
  validates_uniqueness_of :guid
end
