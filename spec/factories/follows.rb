FactoryBot.define do
  factory :follow do
    association(:following, factory: :person)
    association(:follower, factory: :person)
  end
end
