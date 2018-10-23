# frozen_string_literal: true

FactoryBot.define do
  factory :status_message do
    text { Faker::Markdown.emphasis }
    author
  end
end
