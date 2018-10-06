FactoryBot.define do
  factory :person do
    profile_name { Faker::Internet.username }
    association :owner, factory: :user
  end
end
