# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:vote) { create(:vote) }

  it { is_expected.to respond_to(:positive) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:author_id) }
  it { is_expected.to respond_to(:target_type) }
  it { is_expected.to respond_to(:target_id) }
  it { should validate_uniqueness_of(:guid) }
  it { should belong_to(:target) }
  it { should belong_to(:author) }

  it 'has a valid factory' do
    expect(build(:vote)).to be_valid
  end
end
