# frozen_string_literal: true

class Comment < ApplicationRecord
  include Fields::Guid
  include Fields::Author

  # Association
  belongs_to :commentable, polymorphic: true
  alias_attribute :post, :commentable
  # alias_attribute :parent, :commentable

  # Validations
  validates :text, presence: true, length: {maximum: 65_535}
end
