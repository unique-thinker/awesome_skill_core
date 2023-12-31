# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile) }

  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:first_name) }
  it { is_expected.to respond_to(:last_name) }
  it { is_expected.to respond_to(:birthday) }
  it { is_expected.to respond_to(:gender) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:bio) }
  it { is_expected.to respond_to(:professions) }
  it { is_expected.to respond_to(:company) }
  it { is_expected.to respond_to(:current_place) }
  it { is_expected.to respond_to(:native_place) }
  it { is_expected.to respond_to(:state) }
  it { is_expected.to respond_to(:country) }
  it { is_expected.to respond_to(:country) }
  it { is_expected.to respond_to(:person_id) }
  it { should belong_to(:person) }

  describe 'validation' do
    describe 'of first_name' do
      it 'cannot have ;' do
        profile.first_name = 'Hex;agon'
        expect(profile).not_to be_valid
      end

      it { should validate_length_of(:first_name).is_at_most(32) }

      it 'can be 32 characters long' do
        profile.first_name = 'Hexagoooooooooooooooooooooooooon'
        expect(profile).to be_valid
      end

      it 'cannot be 33 characters' do
        profile.first_name = 'Hexagooooooooooooooooooooooooooon'
        expect(profile).not_to be_valid
      end

      it 'disallows ; with a newline in the string' do
        profile.first_name = 'H\nex;agon'
        expect(profile).not_to be_valid
      end
    end

    describe 'of last_name' do
      it { should validate_length_of(:last_name).is_at_most(32) }

      it 'can be 32 characters long' do
        profile.last_name = 'Hexagoooooooooooooooooooooooooon'
        expect(profile).to be_valid
      end

      it 'cannot be 33 characters' do
        profile.last_name = 'Hexagooooooooooooooooooooooooooon'
        expect(profile).not_to be_valid
      end

      it 'cannot have ;' do
        profile.last_name = 'Hex;agon'
        expect(profile).not_to be_valid
      end
      it 'disallows ; with a newline in the string' do
        profile.last_name = 'H\nex;agon'
        expect(profile).not_to be_valid
      end
    end
    describe 'of gender' do
      it 'should have only M or F' do
        profile.gender = 'invalid gender'
        expect(profile).not_to be_valid
        expect(profile.errors[:gender]).to include('must be Male or Female')
      end
    end
  end
end
