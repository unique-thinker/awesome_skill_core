# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    text { Faker::Markdown.emphasis }
    association :author, factory: :person
    association :post, factory: :post
  end
end
