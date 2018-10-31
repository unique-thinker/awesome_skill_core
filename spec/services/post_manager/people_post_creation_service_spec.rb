# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostManager::PeoplePostCreationService, type: :service do
  let(:user_1) { create(:user_with_aspects) }
  let(:user_2) { create(:user_with_aspects) }
  let(:aspect) { user_1.aspects.first }
  let(:aspect_list) { create_list(:aspect, 5) }
  let(:pictures) { build_list(:picture, 2) }
  let(:post_params) {
    {
      post_message: build_attributes(:post).slice(:text),
      aspect_ids:   [aspect.id.to_s],
      pictures:     []
    }
  }

  describe '.call' do
    it 'returns the post object without pictures' do
      post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1))
      expect(post).to_not be_nil
      expect(post.guid).to_not be_nil
      expect(post.postable_type).to_not be_nil
      expect(post.postable_id).to_not be_nil
      expect(post.text).to eq(post_params[:post_message][:text])
      expect(post.pictures.first).to be_nil
    end

    context 'with aspect_ids' do
      it 'creates aspect_visibilities for the post' do
        user_1.aspects.create(name: 'another aspect')

        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1))
        expect(post.aspect_visibilities.map(&:aspect)).to eq([aspect])
      end

      it 'does not create aspect_visibilities if the post is public' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, public: true))
        expect(post.aspect_visibilities).to be_empty
      end

      it "raises exception if aspects_ids don't contain any applicable aspect identifiers" do
        bad_ids = [aspect_list.map(&:id).max.next, user_2.aspects.first.id].map(&:to_s)
        expect {
          PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, aspects_ids: bad_ids))
        }.to raise_error(PostManager::PeoplePostCreationService::BadAspectsIDs)
      end
    end

    context 'with public' do
      it 'it creates a public StatusMessage' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, public: true))
        expect(post.public).to be_truthy
      end

      it 'it creates a private StatusMessage' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, public: false))
        expect(post.public).to be_falsey
      end

      it 'it creates a private StatusMessage' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1))
        expect(post.public).to be_falsey
      end
    end

    context 'with pictures' do
      it 'it attaches all pictures' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, pictures: pictures))
        pictures = post.pictures
        expect(pictures.size).to eq(2)
      end

      it 'does not attach pictures without photos param' do
        post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1))
        expect(post.pictures).to be_empty
      end

      context 'with aspect_ids' do
        it 'it marks the pictures as non-public if the post is non-public' do
          post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, pictures: pictures))
          post.pictures.each do |pic|
            expect(pic.public).to be_falsey
          end
        end

        it 'creates aspect_visibilities for the Picture' do
          user_1.aspects.create(name: 'another aspect')

          post = PostManager::PeoplePostCreationService.call(post_params.merge!(user: user_1, pictures: pictures))
          post.pictures.each do |pic|
            expect(pic.aspect_visibilities.map(&:aspect)).to eq([aspect])
          end
        end
      end
    end
  end
end
