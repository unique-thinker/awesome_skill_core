require 'rails_helper'

RSpec.describe MediaAttachment, type: :model do
  it { is_expected.to respond_to(:public) }
  it { is_expected.to respond_to(:kind) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:remote_file_path) }
  it { is_expected.to respond_to(:remote_file_name) }
  it { is_expected.to respond_to(:random_string) }
  it { is_expected.to respond_to(:file) }
  it { is_expected.to respond_to(:views_count) }
  it { is_expected.to respond_to(:content_type) }
  it { is_expected.to respond_to(:size) }
  it { is_expected.to respond_to(:file_meta) }
  it { should belong_to(:author) }
  it { should belong_to(:attachable) }

  it 'has a valid image attachment factory' do
    expect(build(:image_attachment)).to be_valid
  end

  it 'has a valid video attachment factory' do
    expect(build(:video_attachment)).to be_valid
  end
end
