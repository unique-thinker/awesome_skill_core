require 'rails_helper'

RSpec.describe Categorization, type: :model do
  it { should belong_to(:category) }
  it { should belong_to(:post) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:post) }

  it 'has a valid factory' do
    expect(build(:categorization)).to be_valid
  end
end
