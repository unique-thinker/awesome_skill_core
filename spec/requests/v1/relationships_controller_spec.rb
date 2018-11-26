# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RelationshipsController, type: :request do
  # URL
  let(:follow_path)   { '/follow' }
  let(:unfollow_path)   { '/unfollow' }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:person1) { user1.person }
  let(:person2) { user2.person }
  let(:relationship_params) {{ guid: person2.guid }}

  describe 'unauthenticated' do
    it 'POST /follow responds with 401 Unauthorized' do
      post follow_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'DELETE /unfollow responds with 401 Unauthorized' do
      delete unfollow_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authenticated' do
    before do
      login(user1)
    end

    describe 'POST /follow' do
      it 'responds with 201' do
        post follow_path, params: relationship_params, headers: api_headers(response.headers)
        expect(response.status).to eq 201
        expect(Follow.count).to eq person1.following_relationships.count
      end

      it 'responds with 422' do
        post follow_path, params: { guid: guid }, headers: api_headers(response.headers)
        expect(response.status).to eq 422
        expect(Follow.count).to eq person1.following_relationships.count
      end

      it 'shouldn’t be able to follow ourself' do
        post follow_path, params: { guid: person1.guid}, headers: api_headers(response.headers)
        expect(response.status).to eq 422
        expect(Follow.count).to eq person1.following_relationships.count
      end

      it 'shouldn’t be able to following again, if they’re already following' do
        user1.follow(user2.person)
        post follow_path, params: relationship_params, headers: api_headers(response.headers)
        expect(response.status).to eq 422
        expect(Follow.count).to eq person1.following_relationships.count
      end

      it 'should be able to following each other' do
        user2.follow(user1.person)
        post follow_path, params: relationship_params, headers: api_headers(response.headers)
        expect(response.status).to eq 201
        expect(Follow.count).to eq 2
      end
    end

    describe 'DELETE /unfollow' do
      it 'responds with 204' do
        user1.follow(user2.person)
        delete unfollow_path, params: relationship_params, headers: api_headers(response.headers)
        expect(response.status).to eq 204
        expect(Follow.count).to eq person1.following_relationships.count
      end

      it 'responds with 422' do
        delete unfollow_path, params: { guid: guid }, headers: api_headers(response.headers)
        expect(response.status).to eq 422
        expect(Follow.count).to eq person1.following_relationships.count
      end

      it 'shouldn\'t be able to unfollow, if they aren\'t following' do
        user1.follow(user2.person)
        person3 = create(:person)
        delete unfollow_path, params: { guid: person3.guid }, headers: api_headers(response.headers)
        expect(response.status).to eq 422
        expect(Follow.count).to eq person1.following_relationships.count
      end
    end
  end
end
