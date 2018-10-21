# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :rememberable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  before_validation :strip_and_downcase_username

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :username, format: {with: /\A[A-Za-z0-9_]+\z/}
  validates :person, presence: true
  validates_associated :person

  # Association
  has_one :person, inverse_of: :owner, foreign_key: :owner_id, dependent: :destroy

  has_many :aspects, -> { order('order_id ASC') }

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
end
