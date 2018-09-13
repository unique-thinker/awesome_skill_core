# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :rememberable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  validates_presence_of :username, :encrypted_password
  validates :username, uniqueness: { case_sensitive: false }
end
