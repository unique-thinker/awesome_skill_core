# frozen_string_literal: true

class Aspect < ApplicationRecord
  # Association
  belongs_to :user
  has_many :aspect_visibilities, dependent: :destroy
  has_many :posts, through: :aspect_visibilities, source: :shareable, source_type: 'Post'
  has_many :pictures, through: :aspect_visibilities, source: :shareable, source_type: 'Picture'

  # Validations
  validates :name, presence: true, length: {maximum: 20}, null: false
  validates :name, uniqueness: {scope: :user_id, case_sensitive: false}
  validates_associated :user

  before_create do
    self.order_id ||= Aspect.where(user_id: user_id).maximum(:order_id || 0).to_i + 1
  end

  def to_s
    name
  end

  def << (shareable)
    case shareable
      when Post
        self.posts << shareable
      when Picture
        self.pictures << shareable
      else
        raise "Unknown shareable type '#{shareable.class.base_class.to_s}'"
    end
  end
end
