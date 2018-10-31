# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PeoplePostsController, type: :request do
  # URL
  let(:create_post_path) { "/people/#{person.id}/people_posts" }

  let!(:user) { create(:user_with_aspects) }
  let(:person) { user.person }
  let(:aspect_1) { user.aspects.first }
  let(:people_post) { build(:post) }

  let(:post_valid_params) {
    {
      post_message: {text: people_post.text},
      aspect_ids: [aspect_1.id.to_s]
    }
  }

  describe 'unauthenticated' do
    it 'responds with 401 Unauthorized' do
      post create_post_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authenticated' do
    before do
      login(user)
    end

    describe 'POST /people/:person_id/people_posts' do
      context 'with valid params' do
        it 'create a post' do
          post create_post_path, params: post_valid_params, headers: api_headers(response.headers)
          expect(response.status).to eq(201)
        end
      end

      context 'with invalid params' do
        it 'should not create post' do
          post create_post_path,
            params: post_valid_params.merge(post_message: {text: 'abcde12345' * 8000}),
            headers: api_headers(response.headers)
          expect(response.status).to eq(403)
        end
      end
      context 'with aspect_ids' do
        before do
          @aspect_2 = user.aspects.create(name: 'my apsect')
        end

        it 'takes one aspect as array in aspect_ids' do
          post create_post_path, params: post_valid_params, headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          post = Post.find_by_text(people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to eq([aspect_1])
        end

        it 'takes one aspect as string in aspect_ids' do
          post create_post_path, params: post_valid_params.merge(aspect_ids: aspect_1.id.to_s), headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          post = Post.find_by_text(people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to eq([aspect_1])
        end

        it 'takes public as array in aspect_ids' do
          post create_post_path, params: post_valid_params.merge(aspect_ids: ['public']), headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          post = Post.find_by_text(people_post.text)
          expect(post.public).to be_truthy
        end

        it 'takes public as string in aspect_ids' do
          post create_post_path, params: post_valid_params.merge(aspect_ids: 'public'), headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          post = Post.find_by_text(people_post.text)
          expect(post.public).to be_truthy
        end

        it 'takes all_aspect as array in aspect_ids' do
          post create_post_path, params: post_valid_params.merge(aspect_ids: ['all_aspects']), headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          post = Post.find_by_text(people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to match_array(user.aspects)
        end

        it 'takes all_aspect as string in aspect_ids' do
          post create_post_path, params: post_valid_params.merge(aspect_ids: 'all_aspects'), headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          post = Post.find_by_text(people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to match_array(user.aspects)
        end
      end

      context 'with pictures' do
        before do
          image_files = [Rack::Test::UploadedFile.new(
              Rails.root.join($fixtures_dir, 'picture.png').to_s, "image/png"
            )]
          post_valid_params.merge(image_file: image_files)
        end

        it 'will post a picture without text' do
          post_valid_params.delete :text
          post create_post_path, params: post_valid_params, headers: api_headers(response.headers)
          expect(response.status).to eq(201)
        end
      end
    end
  end
end
