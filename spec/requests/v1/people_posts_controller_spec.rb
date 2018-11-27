# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PeoplePostsController, type: :request do
  # URL
  let(:create_post_path) { "/people/#{person.id}/people_posts" }
  let(:destroy_post_path) { "/people/#{person.id}/people_posts/#{people_post.id}" }

  let(:user) { people_post.postable.owner }
  let(:person) { user.person }
  let(:aspect_1) { user.aspects.first }
  let(:aspect_2) { user.aspects.build(name: 'my apsect') }
  let(:people_post) { build(:post) }

  let(:post_valid_params) {
    {
      post_message: {text: people_post.text},
      aspect_ids:   [aspect_1.id.to_s]
    }
  }

  describe 'POST /people/:person_id/people_posts' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post create_post_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user)
      end

      it 'create a post with valid params' do
        post create_post_path,
             params:  post_valid_params,
             headers: api_headers(response.headers)
        expect(response).to have_http_status(201)
      end

      it 'should not create post with invalid params' do
        post create_post_path,
             params:  post_valid_params.merge(post_message: {text: 'abcde12345' * 8000}),
             headers: api_headers(response.headers)
        expect(response).to have_http_status(403)
      end

      context 'with aspect_ids' do
        before do
          aspect_2.save
        end

        it 'takes one aspect as array in aspect_ids' do
          post create_post_path,
               params:  post_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          post = Post.find_by(text: people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to eq([aspect_1])
        end

        it 'takes one aspect as string in aspect_ids' do
          post create_post_path,
               params:  post_valid_params.merge(aspect_ids: aspect_1.id.to_s),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          post = Post.find_by(text: people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to eq([aspect_1])
        end

        it 'takes public as array in aspect_ids' do
          post create_post_path,
               params:  post_valid_params.merge(aspect_ids: ['public']),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          post = Post.find_by(text: people_post.text)
          expect(post.public).to be_truthy
        end

        it 'takes public as string in aspect_ids' do
          post create_post_path,
               params:  post_valid_params.merge(aspect_ids: 'public'),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          post = Post.find_by(text: people_post.text)
          expect(post.public).to be_truthy
        end

        it 'takes all_aspect as array in aspect_ids' do
          post create_post_path,
               params:  post_valid_params.merge(aspect_ids: ['all_aspects']),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          post = Post.find_by(text: people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to match_array(user.aspects)
        end

        it 'takes all_aspect as string in aspect_ids' do
          post create_post_path,
               params:  post_valid_params.merge(aspect_ids: 'all_aspects'),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          post = Post.find_by(text: people_post.text)
          expect(post.aspect_visibilities.map(&:aspect)).to match_array(user.aspects)
        end
      end

      context 'with pictures' do
        before do
          @image_files = [Rack::Test::UploadedFile.new(
            Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png'
          )]
        end

        it 'will post a picture without text' do
          post_valid_params.delete :text
          post create_post_path,
               params:  post_valid_params.merge(image_files: @image_files),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
        end
      end
    end
  end

  describe 'DELETE /people/:person_id/:id' do
    context 'when unauthenticated' do
      before do
        people_post.save
      end

      it 'responds with 401 Unauthorized' do
        delete destroy_post_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        people_post.save
      end

      context 'with own post' do
        before do
          login(user)
        end

        it 'destroy post when it is your post' do
          delete destroy_post_path,
                 params:  {id: people_post.id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(204)
        end
      end

      context 'with post of another user' do
        it 'will response 404' do
          @user = create(:user_with_aspects)
          login(@user)

          delete destroy_post_path,
                 params:  {id: people_post.id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
