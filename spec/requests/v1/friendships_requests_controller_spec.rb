# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FriendshipRequestsController, type: :request do
  # URL
  let(:friend_request_path)   { '/friendship_requests' }
  let(:send_friend_request_path)   { '/friendship_requests' }
  let(:accept_friend_request_path) { "/friendship_requests/#{user2.person.id}" }
  let(:cancel_friend_request_path) { "/friendship_requests/#{user2.person.id}" }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user1_friends) { create_list(:friendship, 5, user: user1, confirmed: true) }
  let(:user1_send_friend_request) { build(:friendship, user: user1, friend: user2.person, confirmed: false) }
  let(:user2_send_friend_request) { build(:friendship, user: user2, friend: user1.person, confirmed: false) }
  let(:friendship_params) { {id: user2.person.id} }

  describe 'GET /friendships' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post friend_request_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user1)
      end

      it 'return incoming friend requests and send friend requests' do
        user1_friends
        user1_send_friend_request.save
        user2_send_friend_request.save
        get friend_request_path, headers: api_headers(response.headers)
        expect(response).to have_http_status(200)
        data = json_response[:data]
        expect(data[:friend_request][0][:relationships][:friend][:data][:id]).to eq (user2.person.id.to_s)
        expect(data[:send_friend_request][0][:relationships][:friend][:data][:id]).to eq (user2.person.id.to_s)
      end
    end
  end

  describe 'POST /friendships' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        post send_friend_request_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user1)
      end

      it 'send a friend request with valid params' do
        post send_friend_request_path,
             params: friendship_params,
             headers: api_headers(response.headers)
        expect(response).to have_http_status(201)
        expect(Friendship.count).to eq 1
      end

      it 'send a friend request with invalid params' do
        post send_friend_request_path,
             params: {id: 8_888_888},
             headers: api_headers(response.headers)
        expect(response).to have_http_status(404)
        expect(Friendship.count).to eq 0
      end

      it 'won’t be able to befriend himself' do
        post send_friend_request_path,
             params: { id: user1.id },
             headers: api_headers(response.headers)
        expect(response).to have_http_status(422)
        expect(Friendship.count).to eq 0
      end

      it 'shouldn’t be able to send friend requests, if they’re already friends' do
        post send_friend_request_path,
             params: friendship_params,
             headers: api_headers(response.headers)
        post send_friend_request_path,
             params: friendship_params,
             headers: api_headers(response.headers)
        expect(response).to have_http_status(422)
        expect(Friendship.count).to eq 1
      end

      it 'shouldn’t be able to send friend requests, if they’re already send friend request' do
        user2_send_friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        post send_friend_request_path,
             params: friendship_params,
             headers: api_headers(response.headers)
        expect(response).to have_http_status(422)
        expect(Friendship.count).to eq 2
      end
    end
  end

  describe 'PATCH /friendships/:id' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        patch accept_friend_request_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user1)
      end

      it 'accept a friend request' do
        user2_send_friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
        expect(Friendship.where(confirmed: true).count).to eq 2
      end

      it 'not accept a friend request and return error' do
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        expect(response).to have_http_status(422)
        expect(Friendship.count).to eq 0
        expect(Friendship.where(confirmed: true).count).to eq 0
      end

      it 'shouldn’t be able to accept friend requests, if they’re already friends' do
        user2_send_friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        expect(response).to have_http_status(422)
        expect(Friendship.where(confirmed: true).count).to eq 2
      end
    end
  end

  describe 'DELETE /friendships/:id' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        delete cancel_friend_request_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user1)
      end

      it 'cancel a send friend request' do
        create(:friendship, user: user1, friend: user2.person, confirmed: false)
        delete cancel_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
        expect(Friendship.count).to eq 0
      end

      it 'cancel a coming friend request' do
        user2_send_friend_request.save
        delete cancel_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
        expect(Friendship.count).to eq 0
      end

      it 'unfriend a friend' do
        user2_send_friend_request.save
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        delete cancel_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
        expect(Friendship.count).to eq 0
      end

      it 'should not unfriend other friends' do
        user1_friends
        user2_send_friend_request.save
        friend_count = user1.friends.count
        patch accept_friend_request_path,
              params:  friendship_params,
              headers: api_headers(response.headers)
        delete cancel_friend_request_path,
               params:  friendship_params,
               headers: api_headers(response.headers)
        expect(response).to have_http_status(204)
        expect(Friendship.where(user: user1, confirmed: true).count).to eq friend_count
      end

      it 'should return error' do
        user1_friends
        user2_send_friend_request.save
        friend_count = user1.friends.count
        user3 = create(:user)
        delete "/friendship_requests/#{user3.person.id}",
               params:  {id: user3.person.id},
               headers: api_headers(response.headers)
        expect(response).to have_http_status(422)
        expect(Friendship.where(user: user1, confirmed: true).count).to eq friend_count
      end
    end
  end
end
