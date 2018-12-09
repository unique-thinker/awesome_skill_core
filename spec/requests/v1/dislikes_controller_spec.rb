# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DislikesController, type: :request do
  # URL
  let(:create_dislike_path) { "/posts/#{user_post.id}/dislikes" }
  let(:destroy_dislike_path) { "/posts/#{user_post.id}/dislikes/#{dislike.id}" }

  let(:dislike) { build(:dislike) }
  let!(:user_post) { dislike.parent }
  let(:user) { user_post.author.owner }
  let(:another_user) { create(:user) }
  let(:dislike_valid_params) { {post_id: user_post.id} }

  describe 'POST /posts/:post_id/dislikes' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post create_dislike_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
        expect(user_post.dislikes.count).to eq 0
      end
    end

    context 'when authenticated' do
      before do
        login(user)
      end

      context 'with valid params' do
        it 'dislike a post' do
          post create_dislike_path,
               params:  dislike_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          dislikes = user_post.dislikes
          expect(dislikes.count).to eq 1
          expect(PublicActivity::Activity.where(trackable: dislikes).count).to eq 1
        end

        it 'dislike a like post and destroy like' do
          user.like!(user_post)
          post create_dislike_path,
               params:  dislike_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          expect(user_post.likes.count).to eq 0
          dislikes = user_post.dislikes
          expect(dislikes.count).to eq 1
          expect(PublicActivity::Activity.where(trackable: dislikes).count).to eq 1
        end
      end

      context 'on a post from a stranger' do
        it 'doesn\'t dislike a post' do
          another_user_post = create(:post_in_aspect)
          post "/posts/#{another_user_post.id}/dislikes",
               params:  {post_id: another_user_post.id},
               headers: api_headers(response.headers)
          expect(user).not_to receive(:dislike!)
          expect(response).to have_http_status(404)
          dislikes = user_post.dislikes
          expect(dislikes.count).to eq 0
          expect(PublicActivity::Activity.where(trackable: dislikes).count).to eq 0
        end
      end
    end
  end

  describe 'DELETE /posts/:post_id/dislikes/:id' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post destroy_dislike_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        dislike.save
        login(user)
      end

      it 'lets a user destroy their dislike' do
        delete destroy_dislike_path,
               params:  dislike_valid_params.merge(id: dislike.id),
               headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
      end

      it 'does not a user destroy other dislikes' do
        dislike2 = another_user.dislike!(user_post)
        dislike_count = Dislike.count

        delete "/posts/#{user_post.id}/dislikes/#{dislike2.id}",
               params:  dislike_valid_params.merge(id: dislike2.id),
               headers: api_headers(response.headers)
        expect(response).to have_http_status(403)
        expect(Dislike.count).to eq(dislike_count)
      end
    end
  end
end
