# frozen_string_literal: true

class Aspect < ApplicationRecord
  # Association
  belongs_to :user
  has_many :aspect_visibilities, dependent: :destroy
  has_many :posts, through: :aspect_visibilities, source: :shareable, source_type: 'Post'
  has_many :attachments, through: :aspect_visibilities, source: :shareable, source_type: 'MediaAttachment'

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

  def <<(shareable)
    case shareable
    when Post
      posts << shareable
    when MediaAttachment
      attachments << shareable
    else
      raise "Unknown shareable type '#{shareable.class.base_class}'"
    end
  end
end
