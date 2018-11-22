# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user, inverse_of: :friendships
  belongs_to :friend, class_name: 'Person', inverse_of: :friendships
  validates :friend_id, uniqueness: {scope: :user_id}
end
