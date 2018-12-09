# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :request do
  # URL
  let(:create_comment_path) { "/posts/#{user_post.id}/comments" }
  let(:destroy_comment_path) { "/posts/#{user_post.id}/comments/#{comment.id}" }

  let(:comment) { build(:comment) }
  let!(:user_post) { comment.commentable }
  let(:user) { user_post.postable.owner }
  let(:person) { user_post.postable }
  let(:another_user) { create(:user) }
  let(:comment_valid_params) {
     {
       post_id: user_post.id,
       comment: {text: comment.text}
     }}

  describe 'POST /posts/:post_id/comments' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post create_comment_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
        expect(user_post.comments.count).to eq 0
      end
    end

    context 'when authenticated' do
      before do
        login(user)
      end

      context 'with valid params' do
        it 'create a comment' do
          post create_comment_path,
               params:  comment_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(201)
          expect(user_post.comments.count).to eq 1
          expect(PublicActivity::Activity.where(trackable_type: 'Comment').count).to eq 1
          expect(json_response[:data][:attributes][:text]).to match comment_valid_params[:comment][:text]
        end
      end

      context 'with invalid params' do
        it 'should not create comment' do
          post create_comment_path,
               params:  comment_valid_params.merge(comment: {text: 'abcde12345' * 8000}),
               headers: api_headers(response.headers)
          expect(response).to have_http_status(403)
          expect(user_post.comments.count).to eq 0
          expect(PublicActivity::Activity.where(trackable_type: 'Comment').count).to eq 0
        end

        it 'posts no comment on a post from a stranger' do
          another_user_post = create(:post_in_aspect)
          post "/posts/#{another_user_post.id}/comments",
               params:  comment_valid_params,
               headers: api_headers(response.headers)
          expect(response).to have_http_status(404)
          expect(user_post.comments.count).to eq 0
          expect(PublicActivity::Activity.where(trackable_type: 'Comment').count).to eq 0
          expect(json_response[:error]).to eq('Failed to comment.')
        end
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    before do
      comment.save
    end

    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        delete destroy_comment_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      context 'with own post' do
        before do
          login(user)
        end

        it 'lets the user delete their comment' do
          delete destroy_comment_path,
                 params:  {id: comment.id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(204)
        end

        it 'lets the user destroy other people\'s comments' do
          comment = another_user.comment!(user_post, 'hey')
          delete "/posts/#{user_post.id}/comments/#{comment.id}",
                 params:  {id: comment.id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(204)
        end
      end

      context 'with another user\'s post' do
        before do
          login(another_user)
        end

        it 'lets the user delete their comment' do
          comment = another_user.comment!(user_post, 'hey')
          delete "/posts/#{user_post.id}/comments/#{comment.id}",
                 params:  {id: comment.id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(204)
        end

        it 'does not let the user destroy comments they do not own' do
          @comment = another_user.comment!(user_post, 'hey')
          delete destroy_comment_path,
                 params:  {id: comment.id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(403)
        end

        it 'return 404 on nonexistent comment' do
          nonexistent_comment_id = 404_404
          delete "/posts/#{user_post.id}/comments/#{nonexistent_comment_id}",
                 params:  {id: nonexistent_comment_id},
                 headers: api_headers(response.headers)
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
