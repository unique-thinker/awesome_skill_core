# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    association(:user, factory: :user)
    association(:friend, factory: :person)
    type { Friendship.types.keys.sample }
    status { Friendship.statuses.keys.sample }
  end
end
