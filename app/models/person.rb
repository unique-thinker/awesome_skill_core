# frozen_string_literal: true

class Person < ApplicationRecord
  include Fields::Guid

  # Validations
  validates :profile_name, presence: true, uniqueness: true
  validates :profile, presence: true

  # Association
  belongs_to :owner, class_name: 'User', optional: true
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_many :posts, as: :postable, dependent: :destroy
  has_many :friendships, foreign_key: :friend_id, dependent: :destroy, inverse_of: :friend

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow', inverse_of: :following
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow', inverse_of: :follower

  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following, through: :following_relationships, source: :following

  # Set a default of an empty profile when a new Person record is instantiated.
  # Passing :profile => nil to Person.new will instantiate a person with no profile.
  # Calling Person.new with a block:
  #   Person.new do |p|
  #     p.profile = nil
  #   end
  # will not work!  The nil profile will be overriden with an empty one.
  def initialize(params)
    params ||= {}
    profile_set = params.has_key?(:profile) || params.has_key?('profile')
    params[:profile_attributes] = params.delete(:profile) if params.has_key?(:profile) && params[:profile].is_a?(Hash)
    super
    self.profile ||= Profile.new unless profile_set
  end

  def owns?(obj)
    id == obj.author.id
  end

  def follow(following_person)
    following_relationships.build(following: following_person)
    save
  end

  def unfollow(following_person)
    following_relationships.find_by(following: following_person)&.destroy
  end
end
