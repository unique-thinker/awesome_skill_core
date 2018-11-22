# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FriendshipsController, type: :request do
  # URL
  let(:send_friend_request_path)   { '/friendships' }
  let(:accept_friend_request_path) { "/friendships/#{user2.person.id}" }
  let(:cancel_friend_request_path) { "/friendships/#{user2.person.id}" }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user1_friends) { create_list(:friendship, 5, user: user1) }
  let(:friend_request) { build(:friendship, user: user2, friend: user1.person, confirmed: false) }
  let(:friendship_params) { {id: user2.person.id} }

  describe 'unauthenticated' do
    it 'responds with 401 Unauthorized' do
      post send_friend_request_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
    it 'responds with 401 Unauthorized' do
      patch accept_friend_request_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
    it 'responds with 401 Unauthorized' do
      delete cancel_friend_request_path, headers: api_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authenticated' do
    before do
      login(user1)
    end

    describe 'POST /friendships' do
      it 'send a friend request with valid params' do
        post send_friend_request_path,
             params:  friendship_params,
             headers: api_headers(response.headers)
        expect(response.status).to eq(201)
        expect(Friendship.count).to eq 1
      end

      it 'send a friend request with invalid params' do
        post send_friend_request_path,
             params:  {friend_id: 8_888_888},
             headers: api_headers(response.headers)
        expect(response.status).to eq(404)
        expect(Friendship.count).to eq 0
      end
    end

    describe 'PATCH /friendships/:id' do
      it 'accept a friend request' do
        friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        expect(response.status).to eq(204)
        expect(Friendship.where(confirmed: true).count).to eq 2
      end

      it 'not accept a friend request and return error' do
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        expect(response.status).to eq(422)
        expect(Friendship.count).to eq 0
        expect(Friendship.where(confirmed: true).count).to eq 0
      end
    end

    describe 'DELETE /friendships/:id' do
      it 'cancel a send friend request' do
        create(:friendship, user: user1, friend: user2.person, confirmed: false)
        delete accept_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response.status).to eq(204)
        expect(Friendship.count).to eq 0
      end

      it 'cancel a coming friend request' do
        friend_request.save
        delete accept_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response.status).to eq(204)
        expect(Friendship.count).to eq 0
      end

      it 'unfriend a friend' do
        friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        delete accept_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response.status).to eq(204)
        expect(Friendship.count).to eq 0
      end

      it 'should not unfriend other friends' do
        user1_friends
        friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        friend_count = Friendship.count
        delete accept_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response.status).to eq(204)
        expect(Friendship.count).to eq friend_count - 2
      end

      it 'should return error' do
        user1_friends
        friend_request.save
        friend_count = Friendship.count
        user3 = create(:user)
        delete "/friendships/#{user3.person.id}",
               params:  {id: user3.person.id},
               headers: api_headers(response.headers)
        expect(response.status).to eq(422)
        expect(Friendship.count).to eq friend_count
      end
    end
  end
end
