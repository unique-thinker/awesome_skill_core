# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aspect, type: :model do
  let!(:aspect) { create(:aspect) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:user_id) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  it { should belong_to(:user) }
  it { should validate_length_of(:name).is_at_most(20) }
end
