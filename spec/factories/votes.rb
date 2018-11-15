FactoryBot.define do
  factory :vote do
    positive { Faker::Boolean.boolean }
    association :author, :factory => :person
    association :target, :factory => :post
  end
end
