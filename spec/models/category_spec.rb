# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:type) }
  it { should validate_presence_of(:guid) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }
  it { should have_many(:categorizations) }
  it { should have_many(:posts).through(:categorizations) }

  it 'has a valid factory' do
    expect(build(:category)).to be_valid
  end

  describe 'validations' do
    it 'guid must be uniqe' do
      create(:category)
      should validate_uniqueness_of(:guid)
    end

    it 'type should be ENUM' do
      expect { build(:category, type: 'post') }.to raise_error(ArgumentError)
    end
  end
end
