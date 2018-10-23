# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusMessage, type: :model do
  let!(:user) { create(:user) }
  let!(:aspect) { user.aspects.first }
  let(:status) { build(:status_message) }

  it { is_expected.to respond_to(:public) }
  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:text) }
  it { is_expected.to respond_to(:type) }
  it { is_expected.to respond_to(:author) }
  it { should belong_to(:author) }
  it { should validate_length_of(:text).is_at_most(65_535) }

  describe 'emptiness' do
    it 'needs either a message or at least one photo' do
      post = user.build_post(:status_message, text: nil)
      expect(post).not_to be_valid

      post.text = ''
      expect(post).not_to be_valid

      post.text = 'wales'
      expect(post).to be_valid
      post.text = nil
    end

    it 'also checks for content when author is remote' do
      post = status
      post.text = nil
      expect(post).not_to be_valid
    end
  end

  describe 'validation' do
    it 'should not be valid if the author is missing' do
      status.author = nil
      expect(status).not_to be_valid
    end
  end
end
