# frozen_string_literal: true

FactoryBot.define do
  factory :picture do |_pic|
    title { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    sequence(:random_string) {|_n| SecureRandom.hex(10) }
    association :author, factory: :person
    association :imageable, factory: :post

    after(:build) do |p|
      p.processed_image.store! Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/jpeg'
      )
      p.update_remote_path
    end
  end

  factory(:remote_photo, parent: :picture) do
    remote_image_path { Faker::Internet.url }
    remote_image_name { Faker::File.file_name }
    processed_image { nil }
  end
end
