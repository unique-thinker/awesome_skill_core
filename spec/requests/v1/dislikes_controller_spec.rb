# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DislikesController, type: :request do
  # URL
  let(:create_dislike_path) { "/posts/#{user_post.id}/dislikes" }

  let!(:user_post) { create(:post_in_aspect) }
  let(:user) { user_post.postable.owner }
  let(:dislike_valid_params) { {post_id: user_post.id} }

  describe 'unauthenticated' do
    it 'responds with 401 Unauthorized' do
      post create_dislike_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authenticated' do
    before do
      login(user)
    end

    describe 'POST /posts/:post_id/dislikes' do
      context 'with valid params' do
        it 'dislike a post' do
          post create_dislike_path,
               params:  dislike_valid_params,
               headers: api_headers(response.headers)
          expect(response.status).to eq(201)
        end
      end

      context 'on a post from a stranger' do
        it 'doesn\'t dislike a post' do
          another_user_post = create(:post_in_aspect)
          post "/posts/#{another_user_post.id}/dislikes",
               params:  {post_id: another_user_post.id},
               headers: api_headers(response.headers)
          expect(user).not_to receive(:dislike!)
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
