# frozen_string_literal: true

FactoryBot.define do
  factory :aspect do
    sequence(:name) { |n| "#{%w[Family Friends Work Acquaintances].sample}#{n}" }
    user
  end
end
