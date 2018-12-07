# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :request do
  # URL
  let(:edit_profile_path) { '/profile/edit' }
  let(:update_profile_path) { '/profile' }
  let(:update_profile_pic_path) { '/profile/update_picture' }

  # create test user
  let!(:user) { create(:user) }
  let(:valid_profile_params) { build(:profile).attributes.except('id', 'person_id', 'created_at', 'updated_at') }
  let(:updated_profile_pic_params) {
     {
       file: Rack::Test::UploadedFile.new(
         Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png'
       )
     }}
  let(:invalid_profile_params) {
     {
       first_name:    'a' * 40,
       last_name:     'a' * 40,
       birthday:      1.year.ago,
       gender:        'male',
       status:        'status',
       bio:           'bio' * 100,
       professions:   'Dancing',
       company:       'Dancing.com',
       current_place: 'indore',
       native_place:  'indore',
       state:         'madhya pradesh',
       country:       'india'
     }}

  describe 'GET /profile/edit' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        get edit_profile_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user)
        get edit_profile_path, headers: api_headers(response.headers)
      end

      it 'succeeds' do
        expect(response).to have_http_status(:ok)
      end

      it 'should contains expected recipe attributes' do
        body = json_response
        expect(body[:data].keys).to match_array(%i[id type attributes meta])
        expect(body[:data][:attributes].keys).to match_array(%i[
                                                               first_name
                                                               last_name
                                                               birthday
                                                               gender
                                                               status
                                                               bio
                                                               professions
                                                               company
                                                               current_place
                                                               native_place
                                                               state
                                                               country
                                                             ])
      end
    end
  end

  describe 'PATCH /profile' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        patch update_profile_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user)
      end

      context 'with valid params' do
        before do
          patch update_profile_path, params: {profile: valid_profile_params}, headers: api_headers(response.headers)
        end

        it 'succeeds' do
          expect(response).to have_http_status(:no_content)
          profile = user.person.profile.reload
          expect(profile.first_name).to eq valid_profile_params['first_name']
          expect(profile.last_name).to eq valid_profile_params['last_name']
          expect(profile.birthday).to eq valid_profile_params['birthday']
          expect(profile.gender).to eq valid_profile_params['gender']
          expect(profile.status).to eq valid_profile_params['status']
          expect(profile.bio).to eq valid_profile_params['bio']
          expect(profile.professions).to eq valid_profile_params['professions']
          expect(profile.current_place).to eq valid_profile_params['current_place']
          expect(profile.native_place).to eq valid_profile_params['native_place']
          expect(profile.state).to eq valid_profile_params['state']
          expect(profile.country).to eq valid_profile_params['country']
        end
      end

      context 'with invalid params' do
        before do
          patch update_profile_path, params: {profile: invalid_profile_params}, headers: api_headers(response.headers)
        end

        it 'should return errors' do
          expect(response).to have_http_status(:unprocessable_entity)
          body = json_response
          expect(body[:success]).to eq false
          expect(body.keys).to match_array(%i[success errors])
        end
      end
    end
  end

  describe 'PATCH /profile/update_picture' do
    context 'when unauthenticated' do
      it 'responds with 401 Unauthorized' do
        patch update_profile_pic_path, headers: api_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      before do
        login(user)
      end

      it 'succeeds' do
        patch update_profile_pic_path,
              params:  {profile: updated_profile_pic_params},
              headers: api_headers(response.headers)
        expect(response).to have_http_status(:no_content)
        expect(MediaAttachment.count).to eq 1
      end
    end
  end
end
