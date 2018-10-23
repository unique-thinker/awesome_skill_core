# frozen_string_literal: true

FactoryBot.define do
  factory :person, aliases: %i[author] do
    profile_name { Faker::Internet.username }

    after(:build) do |person|
      person.profile = build(:profile, person: person)
    end

    after(:create) do |person|
      person.profile.save
    end
  end
end
