# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Auth::RegistrationsController, type: :request do
  let(:user) { build(:user) }
  let(:valid_user_params) do
    {
      username:              user.username,
      email:                 user.email,
      password:              user.password,
      password_confirmation: user.password
    }.to_json
  end

  let(:invalid_user_params) do
    {
      username:              '',
      email:                 '',
      password:              '',
      password_confirmation: ''
    }.to_json
  end

  describe 'POST /signup' do
    context 'create a user' do
      it 'returns http success' do
        post '/auth', params: valid_user_params, headers: headers
        expect(response).to have_http_status(:success)
        expect(response.has_header?('access-token')).to eq(true)
        user_response = json_response[:data]
        expect(user_response[:username]).to eql user.username
        expect(user_response[:email]).to eql user.email
        expect(User.count).to eql 1
      end
    end

    context 'not created user' do
      it 'with error respnse' do
        post '/auth', params: invalid_user_params, headers: headers
        expect(response).to have_http_status(422)
        response = json_response
        expect(User.count).to eql 0
        user_response_data = response[:data]
        user_response_errors = response[:errors]
        expect(user_response_data[:username]).to eql ''
        expect(user_response_data[:email]).to eql ''
        expect(user_response_errors[:username].first).to eql 'can\'t be blank'
        expect(user_response_errors[:email].first).to eql 'can\'t be blank'
      end
    end
  end
end
