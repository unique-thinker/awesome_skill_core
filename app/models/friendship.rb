class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'Person', inverse_of: :owner
  validates :friend_id, uniqueness: {scope: :user_id}
end
