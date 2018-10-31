# frozen_string_literal: true

FactoryBot.define do
  factory :aspect_visibility do
    aspect

    factory :aspect_visibility_for_post do
      association :shareable, factory: :post
    end

    factory :aspect_visibility_for_picture do
      association :shareable, factory: :picture
    end
  end
end
