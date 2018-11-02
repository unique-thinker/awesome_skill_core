# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[owner] do
    sequence(:username) {|n| "#{Faker::Internet.username('alices')}#{n}#{Faker::Number.hexadecimal(6)}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    after(:build) do |u|
      u.person = build(
        :person,
        profile_name: u.username,
        owner:        u
      ) unless u.person
    end

    after(:create) do |u|
      u.person.save
      u.person.profile.save
    end

    factory :user_with_aspects do
      after(:build) do |u|
        u.aspects = build_list(:aspect, 4, user: u)
      end

      after(:create) do |u|
        u.save
      end
    end
  end
end
