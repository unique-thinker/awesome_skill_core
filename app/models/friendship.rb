# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user, inverse_of: :friendships
  belongs_to :friend, class_name: 'Person', inverse_of: :friendships
  validates :friend_id, uniqueness: {scope: :user_id}
  validate :not_self, :not_friends, :not_pending, on: :create

  private

  def not_self
    errors.add(:friend, 'can\'t be equal to user') if user.person == friend
  end

  def not_friends
    errors.add(:friend, 'is already added') if user.friends.include?(friend)
  end

  def not_pending
    errors.add(:friend, 'already requested friendship') if user.friend_requests.include?(friend)
  end
end
