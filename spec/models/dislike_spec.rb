# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dislike, type: :model do
  it 'has a valid factory' do
    expect(build(:dislike)).to be_valid
  end
end
