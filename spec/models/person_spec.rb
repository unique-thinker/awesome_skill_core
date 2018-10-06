# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to respond_to(:profile_name) }
  it { is_expected.to respond_to(:owner_id) }
  it { should validate_presence_of(:profile_name) }

  it 'does not save automatically' do
    expect(Person.new.persisted?).to be false
  end
end
