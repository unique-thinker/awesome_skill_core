# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    profile_name { Faker::Internet.username }
  end
end
