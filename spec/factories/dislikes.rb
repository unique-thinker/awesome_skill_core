FactoryBot.define do
  factory :dislike do
    positive { Faker::Boolean.boolean(0) }
    association :author, :factory => :person
    association :target, :factory => :post 
  end
end
