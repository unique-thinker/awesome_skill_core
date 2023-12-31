# frozen_string_literal: true

FactoryBot.define do
  factory :post do |_post|
    text { Faker::Markdown.emphasis }
    association :postable, factory: :person

    factory :post_with_picture do
      after(:build) do |p|
        p.pictures = build_list(
          :picture,
          2,
          public: p.public
        )
      end
    end

    factory(:post_in_aspect) do
      public { false }

      after(:build) do |p|
        p.aspects << p.postable.owner.aspects.first
      end
    end
  end
end
