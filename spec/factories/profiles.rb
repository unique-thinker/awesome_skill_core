# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.birthday(18, 65) }
    gender { Faker::Gender.binary_type == 'Male' ? 'M' : 'F' }
    status { Faker::Friends.quote }
    bio { Faker::HowIMetYourMother.quote }
    professions { Faker::Company.profession }
    company { Faker::Company.industry }
    current_place { Faker::Address.city }
    native_place { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    person
  end
end
