# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :request do
  # URL
  let(:create_like_path) { "/posts/#{user_post.id}/likes" }
  let(:destroy_like_path) { "/posts/#{user_post.id}/likes/#{like.id}" }

  let(:like) { build(:like) }
  let!(:user_post) { like.parent }
  let(:user) { user_post.author.owner }
  let(:another_user) { create(:user) }
  let(:like_valid_params) { {post_id: user_post.id} }

  describe 'POST /posts/:post_id/likes' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post create_like_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user)
      end

      context 'with valid params' do
        it 'like a post' do
          post create_like_path,
               params:  like_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
        end

        it 'like a dislike post and destroy dislike' do
          user.dislike!(user_post)
          post create_like_path,
               params:  like_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
        end
      end

      context 'on a post from a stranger' do
        it 'doesn\'t like a post' do
          another_user_post = create(:post_in_aspect)
          post "/posts/#{another_user_post.id}/likes",
               params:  {post_id: another_user_post.id},
               headers: api_headers(response.headers)
          expect(response).to have_http_status(404)
          expect(user).not_to receive(:like!)
        end
      end
    end
  end

  describe 'DELETE /posts/:post_id/likes/:id' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post destroy_like_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        like.save
        login(user)
      end

      it 'lets a user destroy their like' do
        delete destroy_like_path,
               params:  like_valid_params.merge(id: like.id),
               headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
      end

      it 'does not let a user destroy other likes' do
        like2 = another_user.like!(user_post)
        like_count = Like.count

        delete "/posts/#{user_post.id}/likes/#{like2.id}",
               params:  like_valid_params.merge(id: like2.id),
               headers: api_headers(response.headers)
        expect(response).to have_http_status(403)
        expect(Like.count).to eq(like_count)
      end
    end
  end
end
