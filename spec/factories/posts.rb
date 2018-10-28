# frozen_string_literal: true

FactoryBot.define do
  factory :post do |post|
    text { Faker::Markdown.emphasis }
    post.postable { |p| p.association(:user_with_aspects).person }

    factory :post_with_picture do
      after(:build) do |p|
        p.pictures = build_list(
          :picture,
          2,
          public: p.public
        )
      end
    end

    # factory(:post_in_aspect) do
    #   public { false }
    #   after(:build) do |p|
    #     p.aspects << p.postable.owner.aspects.first
    #   end
    # end
  end
end
