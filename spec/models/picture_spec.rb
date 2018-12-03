# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Picture, type: :model do
  it { is_expected.to respond_to(:public) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:text) }
  it { is_expected.to respond_to(:remote_image_path) }
  it { is_expected.to respond_to(:remote_image_name) }
  it { is_expected.to respond_to(:random_string) }
  it { is_expected.to respond_to(:processed_image) }
  it { should belong_to(:imageable) }

  it 'has a valid factory' do
    expect(build(:picture)).to be_valid
  end
end
