# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }
  let!(:status) { create(:status_message) }

  it { should validate_uniqueness_of(:guid) }

  describe 'validations' do
    it 'validates uniqueness of guid and does not throw a db error' do
      expect(FactoryBot.build(:status_message, guid: status.guid)).not_to be_valid
    end
  end

  describe 'post_type' do
    it 'returns the class constant' do
      expect(status.type).to eq('StatusMessage')
    end
  end

  describe '.params_initialize' do
    it 'takes provider_display_name' do
      expect(StatusMessage.params_initialize(status.attributes.merge(author: user.person)).text).to eq(status.text)
    end
  end
end
