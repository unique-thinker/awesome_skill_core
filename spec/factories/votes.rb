# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    positive { Faker::Boolean.boolean }
    association :author, factory: :person
    target { create(:post, postable: author) }
  end
end
