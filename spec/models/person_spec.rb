# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  let!(:person_1) { create(:user).person }
  let(:person_2) { build(:user).person }

  it { is_expected.to respond_to(:guid) }
  it { is_expected.to respond_to(:profile_name) }
  it { is_expected.to respond_to(:owner_id) }
  it { should validate_presence_of(:profile_name) }
  it { should validate_presence_of(:profile) }
  it { should belong_to(:owner) }
  it { should have_one(:profile) }
  it { should have_many(:posts) }

  it 'always has a profile' do
    expect(Person.new.profile).not_to be_nil
  end

  it 'does not save automatically' do
    expect(Person.new.persisted?).to be false
    expect(Person.new.profile.persisted?).to be false
  end

  describe 'validation' do
    it 'validates that no other person with same profile_name exists' do
      person_2.profile_name = person_1.profile_name

      expect(person_2.valid?).to be_falsey
      expect(person_2.errors.full_messages).to include('Profile name has already been taken')
    end
  end
end
