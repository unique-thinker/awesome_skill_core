require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) { create(:comment) }

  it { is_expected.to respond_to(:text) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:author_id) }
  it { is_expected.to respond_to(:commentable_type) }
  it { is_expected.to respond_to(:commentable_id) }
  it { should validate_uniqueness_of(:guid) }
  it { should belong_to(:commentable) }
  it { should validate_length_of(:text).is_at_most(65_535) }
end
