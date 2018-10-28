# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostManager::PeoplePostCreationService, type: :service do
  let(:user) { create(:user_with_aspects) }
  let(:aspect) { user.aspects.first }
  let(:post_params) {
    {
      post_message: build_attributes(:post).slice(:text),
      aspect_ids: [aspect.id.to_s],
      pictures: []
    }
  }

  describe '.call' do
    it 'returns the build post' do
      post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user))
      expect(post).to_not be_nil
      expect(post.guid).to_not be_nil
      expect(post.postable_type).to_not be_nil
      expect(post.postable_id).to_not be_nil
      expect(post.text).to eq(post_params[:post_message][:text])
    end

    context 'with public' do
      it 'it creates a public StatusMessage' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user, public: true))
        expect(post.public).to be_truthy
      end

      it 'it creates a private StatusMessage' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user, public: false))
        expect(post.public).to be_falsey
      end

      it 'it creates a private StatusMessage' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user))
        expect(post.public).to be_falsey
      end
    end
  end
end
