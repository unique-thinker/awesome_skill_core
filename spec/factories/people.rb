# frozen_string_literal: true

FactoryBot.define do
  factory :person, aliases: %i[author] do
    profile_name { Faker::Internet.username }

    after(:build) do |person|
      person.owner = build(:user_with_aspects, person: person) unless person.owner
      person.profile = build(:profile, person: person)
    end

    after(:create) do |person|
      person.owner.save
      person.profile.save
    end
  end
end
