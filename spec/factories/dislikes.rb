# frozen_string_literal: true

FactoryBot.define do
  factory :dislike do
    positive { Faker::Boolean.boolean(0) }
    association :author, factory: :person
    target { create(:post, postable: author) }
  end
end
