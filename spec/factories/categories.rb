# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Company.profession }
    kind { Category.kinds.keys.sample }

    factory :sub_category do
      association :parent, factory: :category
    end
  end
end
