FactoryBot.define do
  factory :categorization do
    association(:category, factory: :category)
    association(:post, factory: :post)
  end
end
