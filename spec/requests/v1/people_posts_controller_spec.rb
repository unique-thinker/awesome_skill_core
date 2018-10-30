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
    aspect_ids: [aspect_1.id.to_s],
    image_attributes: [Rack::Test::UploadedFile.new(
        Rails.root.join($fixtures_dir, 'picture.png').to_s, "image/png"
      )]
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
        before do
          post create_post_path, params: post_valid_params, headers: api_headers(response.headers)
        end
        it 'create a post' do
          binding.pry
        end
      end
    end
  end
end
