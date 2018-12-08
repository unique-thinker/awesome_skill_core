# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Company.profession }
    type { Category.types.keys.sample }

    factory :sub_category do
      association :parent, factory: :category
    end
  end
end
