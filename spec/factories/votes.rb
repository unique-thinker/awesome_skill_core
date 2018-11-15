# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    positive { Faker::Boolean.boolean }
    association :author, factory: :person
    association :target, factory: :post
  end
end
