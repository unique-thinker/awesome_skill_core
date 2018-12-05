# frozen_string_literal: true

class Post < ApplicationRecord
  include Shareable
  include Fields::Votable
  # Association
  belongs_to :postable, polymorphic: true
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :categorizations, inverse_of:  :post
  has_many :categories, through: :categorizations

  # Validations
  validates :text, length: {maximum: 65_535}
  validate :presence_of_content, on: :create
  alias_attribute :author, :postable

  def self.params_initialize(params)
    new(params.to_hash.stringify_keys.slice(*column_names))
  end

  private

  def text_and_pictures_blank?
    text.blank? && pictures.none?
  end

  def presence_of_content
    errors[:base] << 'Cannot create a Picture without content' if text_and_pictures_blank?
  end
end
