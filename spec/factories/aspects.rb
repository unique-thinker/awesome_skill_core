# frozen_string_literal: true

FactoryBot.define do
  factory :aspect do
    name { %w[Family Friends Work Acquaintances].sample }
    user
  end
end
