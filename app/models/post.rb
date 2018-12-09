# frozen_string_literal: true

class Post < ApplicationRecord
  include Shareable
  include Fields::Votable
  # Activity
  include ActivityCallbacks
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model|  controller && controller.current_user }

  # Association
  belongs_to :postable, polymorphic: true
  has_many :attachments, as: :attachable, class_name: 'MediaAttachment', dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :categorizations
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
    text.blank? && attachments.none?
  end

  def presence_of_content
    errors[:base] << 'Cannot create a Picture without content' if text_and_pictures_blank?
  end
end
