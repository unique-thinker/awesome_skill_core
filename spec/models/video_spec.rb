# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  it { is_expected.to respond_to(:public) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:remote_video_path) }
  it { is_expected.to respond_to(:remote_video_name) }
  it { is_expected.to respond_to(:random_string) }
  it { is_expected.to respond_to(:duration) }
  it { is_expected.to respond_to(:height) }
  it { is_expected.to respond_to(:width) }
  it { is_expected.to respond_to(:processed_video) }
  it { is_expected.to respond_to(:views_count) }
  it { should belong_to(:author) }
  it { should belong_to(:videoable) }

  it 'has a valid factory' do
    expect(build(:video)).to be_valid
  end
end
