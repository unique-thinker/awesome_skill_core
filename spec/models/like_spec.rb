# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  it 'has a valid factory' do
    expect(build(:like)).to be_valid
  end
end
