require 'rails_helper'

RSpec.describe Follow, type: :model do
  it { is_expected.to respond_to(:following) }
  it { is_expected.to respond_to(:follower) }
  it { should belong_to(:following) }
  it { should belong_to(:follower) }

  it 'has a valid factory' do
    expect(build(:follow)).to be_valid
  end

  describe 'validations' do
    let(:person1) { create(:person) }
    let(:person2) { create(:person) }
    let(:follow) { build(:follow) }

    it 'validates uniqueness with shoulda-matchers' do
      follow.save
      should validate_uniqueness_of(:follower_id).scoped_to(:following_id)
    end

    it 'validates uniqueness' do
      follow1 = person1.follower_relationships.build(follower: person2)
      expect(follow1).to be_valid

      follow2 = person1.follower_relationships.build(follower: person1)
      expect(follow2).not_to be_valid

      follow3 = person1.following_relationships.build(following: person2)
      expect(follow3).to be_valid

      follow4 = person1.following_relationships.build(following: person1)
      expect(follow4).not_to be_valid
    end
  end
end
