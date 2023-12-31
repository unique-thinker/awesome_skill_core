# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :rememberable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  include Querying
  include SocialActions

  before_validation :strip_and_downcase_username

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :username, format: {with: /\A[A-Za-z0-9_]+\z/}
  validates :person, presence: true
  validates_associated :person

  # Association
  has_one :person, inverse_of: :owner, foreign_key: :owner_id, dependent: :destroy

  has_many :aspects, dependent: :destroy

  has_many :friendships, inverse_of: :user, dependent: :destroy
  has_many :friends, -> { where(friendships: {status: :accepted}) }, through: :friendships, source: :friend
  has_many :friend_requests, -> { where(friendships: {status: :pending}) }, through: :friendships, source: :friend

  # Delegates
  delegate :owns?, :follow, :unfollow, to: :person

  def strip_and_downcase_username
    return if username.blank?

    username.strip!
    username.downcase!
  end

  # ##Helpers############
  def self.build(opts={})
    u = User.new(opts)
    u.set_person
    u
  end

  def set_person
    person = Person.new
    person.profile_name = username
    self.person = person
  end

  def seed_aspects
    aspects.create(name: 'Family')
    aspects.create(name: 'Friends')
    aspects.create(name: 'Work')
    aq = aspects.create(name: 'Acquaintances')
    aq
  end

  ######## Posting ########
  def build_post(class_name, opts={})
    model_class = class_name.to_s.camelize.constantize
    model_class.params_initialize(opts)
  end

  def aspects_from_ids(aspect_ids)
    if (aspect_ids && ['all', :all]).empty?
      aspects
    else
      aspects.where(id: aspect_ids).to_a
    end
  end

  def add_to_streams(post, aspects_to_insert)
    aspects_to_insert.each do |aspect|
      aspect << post
    end
  end

  ######### Friend Request #########
  def send_friend_request(friend)
    friendships.build(friend: friend, type: :social_friend, status: :pending)
    save
  end

  def accept_friend_request(friend)
    friend_request = friend.owner.friendships.where(friend: person).pending.first
    transaction do
      friend_request&.accepted! && friendships.build(friend: friend, type: :social_friend).accepted!
    end
  end

  def unfriend(friend)
    friendship = Friendship.where(user: [self, friend.owner], friend: [friend, person], status: %i[pending accepted])
    !friendship.empty? && friendship.destroy_all
  end
end
