# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(5..8) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    after(:build) do |u|
      u.person = build(
        :person,
        profile_name: u.username,
        owner: u
      )
    end
  end
end
