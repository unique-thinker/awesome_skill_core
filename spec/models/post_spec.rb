# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  it { is_expected.to respond_to(:public) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:text) }
  it { should validate_uniqueness_of(:guid) }
  it { should belong_to(:postable) }
  it { should validate_length_of(:text).is_at_most(65_535) }
end
