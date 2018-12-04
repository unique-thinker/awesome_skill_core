# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    title { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    random_string { SecureRandom.hex(10) }
    views_count { rand(1..100_000) }
    association :author, factory: :person
    association :videoable, factory: :post

    after(:build) do |p|
      p.processed_video.store! Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'alexa_sings_girl_on_fire.mp4'), 'video/mp4'
      )
      p.update_remote_path
    end
  end
end
