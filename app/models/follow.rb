class Follow < ApplicationRecord
  belongs_to :following, foreign_key: 'following_id', class_name: 'Person', inverse_of: :follower_relationships
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'Person', inverse_of: :following_relationships
  validates :follower_id, uniqueness: {scope: :following_id}
  validates :following_id, presence: true
  validates :follower_id, presence: true
  validate :not_self

  private
  def not_self
    errors[:base] << 'You can\'t be follow ourself' if following == follower
  end
end
