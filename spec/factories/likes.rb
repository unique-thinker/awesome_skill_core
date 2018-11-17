# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    positive { Faker::Boolean.boolean(1) }
    association :author, factory: :person
    target { create(:post, postable: author) }
  end
end
