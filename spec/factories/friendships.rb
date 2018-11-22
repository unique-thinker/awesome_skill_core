# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    association(:user, factory: :user)
    association(:friend, factory: :person)
    confirmed { Faker::Boolean.boolean }
  end
end
