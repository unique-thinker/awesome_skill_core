require 'rails_helper'

RSpec.describe DeviseTokenAuth::SessionsController, type: :request do
  # create test user
  let!(:user) { create(:user) }
  # Login url
  let(:sign_in_url) { '/auth/sign_in' }
  # set test valid and invalid credentials
  let(:valid_credentials) do
    {
      email: user.email,
      password: user.password
    }.to_json
  end
  let(:invalid_credentials) do
    {
      email: Faker::Internet.email,
      password: Faker::Internet.password
    }.to_json
  end


  describe 'POST /login' do
    context 'with valid credentials' do
      it 'return success response' do 
        post sign_in_url, params: valid_credentials, headers: headers
        expect(response).to have_http_status(:success)
        expect(response.has_header?('access-token')).to eq(true)
        user_response = json_response[:data]
        expect(user_response[:username]).to eql user.username
        expect(user_response[:email]).to eql user.email
        expect(user_response[:uid]).to eql user.uid
      end
    end

    context 'with invalid credentials' do
      it 'return error response' do 
        post sign_in_url, params: invalid_credentials, headers: headers
        expect(response).to have_http_status(401)
        response = json_response
        expect(response[:success]).to eql false
        expect(response[:errors].first).to eql 'Invalid login credentials. Please try again.'
      end
    end
  end
end