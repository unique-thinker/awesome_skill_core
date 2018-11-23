# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:friend_id) }
  it { is_expected.to respond_to(:confirmed) }
  it { should belong_to(:user) }
  it { should belong_to(:friend) }

  it 'has a valid factory' do
    expect(build(:friendship)).to be_valid
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:person) { create(:person) }
    let(:friendship) { build(:friendship) }

    it 'validates uniqueness with shoulda-matchers' do
      friendship.save
      should validate_uniqueness_of(:friend_id).scoped_to(:user_id)
    end

    it 'validates uniqueness' do
      friendship1 = user.friendships.build(friend: person, confirmed: true)
      expect(friendship1).to be_valid

      friendship2 = user.friendships.build(friend: user.person, confirmed: true)
      expect(friendship2).not_to be_valid
    end
  end
end
