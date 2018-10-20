# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user_1) { build(:user) }
  subject(:user_2) { build(:user) }

  it { is_expected.to respond_to(:username) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:provider) }
  it { is_expected.to respond_to(:uid) }
  it { is_expected.to respond_to(:encrypted_password) }
  it { is_expected.to respond_to(:reset_password_token) }
  it { is_expected.to respond_to(:reset_password_sent_at) }
  it { is_expected.to respond_to(:allow_password_change) }
  it { is_expected.to respond_to(:sign_in_count) }
  it { is_expected.to respond_to(:current_sign_in_at) }
  it { is_expected.to respond_to(:last_sign_in_at) }
  it { is_expected.to respond_to(:current_sign_in_ip) }
  it { is_expected.to respond_to(:last_sign_in_ip) }
  it { is_expected.to respond_to(:confirmation_token) }
  it { is_expected.to respond_to(:confirmed_at) }
  it { is_expected.to respond_to(:confirmation_sent_at) }
  it { is_expected.to respond_to(:unconfirmed_email) }
  it { is_expected.to respond_to(:tokens) }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:person) }
  it { should validate_confirmation_of(:password) }
  it { should have_one(:person) }

  describe 'validation' do
    describe 'of username' do
      it 'requires presence' do
        user_1.username = nil
        expect(user_1).not_to be_valid
      end

      it 'requires uniqueness' do
        user_2.save
        user_1.username = user_2.username
        expect(user_1).not_to be_valid
      end

      it 'downcases username' do
        user_1.username = 'WeIrDcAsE'
        expect(user_1).to be_valid
        expect(user_1.username).to eq('weirdcase')
      end

      it 'fails if the requested username is only different in case from an existing username' do
        user_2.save
        user_1.username = user_2.username.upcase
        expect(user_1).not_to be_valid
      end

      it 'strips leading and trailing whitespace' do
        user_1.username = '      janie   '
        expect(user_1).to be_valid
        expect(user_1.username).to eq('janie')
      end

      it "fails if there's whitespace in the middle" do
        user_1.username = 'bobby tables'
        expect(user_1).not_to be_valid
      end

      it 'can not contain non url safe characters' do
        user_1.username = 'kittens;'
        expect(user_1).not_to be_valid
      end

      it 'should not contain periods' do
        user_1.username = 'kittens.'
        expect(user_1).not_to be_valid
      end
    end

    describe 'of email' do
      it 'requires email address' do
        user_1.email = nil
        expect(user_1).not_to be_valid
      end

      it 'requires a unique email address' do
        user_2.save
        user_1.email = user_2.email
        expect(user_1).not_to be_valid
      end

      it 'requires a valid email address' do
        user_1.email = 'somebodyanywhere'
        expect(user_1).not_to be_valid
      end
    end
  end
end
