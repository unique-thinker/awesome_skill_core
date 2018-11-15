# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :request do
  # URL
  let(:create_comment_path) { "/posts/#{user_post.id}/comments" }

  let!(:user_post) { create(:post_in_aspect) }
  let(:user) { user_post.postable.owner }
  let(:comment_valid_params) {{
    post_id: user_post.id,
    comment: {text: build(:comment).text}
  }}

  describe 'unauthenticated' do
    it 'responds with 401 Unauthorized' do
      post create_comment_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authenticated' do
    before do
      login(user)
    end

    describe 'POST /posts/:post_id/comments' do
      context 'with valid params' do
        it 'create a comment' do
          post create_comment_path,
               params:  comment_valid_params,
               headers: api_headers(response.headers)
          expect(response.status).to eq(201)
          expect(json_response[:data][:attributes][:text]).to match comment_valid_params[:comment][:text]
        end
      end

      context 'with invalid params' do
        it 'should not create comment' do
          post create_comment_path,
               params:  comment_valid_params.merge(comment: {text: 'abcde12345' * 8000}),
               headers: api_headers(response.headers)
          expect(response.status).to eq(403)
        end

        it 'posts no comment on a post from a stranger' do
          another_user_post = create(:post_in_aspect)
          post "/posts/#{another_user_post.id}/comments",
                params:  comment_valid_params,
                headers: api_headers(response.headers)
          expect(response.code).to eq("404")
          expect(json_response[:error]).to eq('Failed to comment.')
        end
      end
    end
  end
end
