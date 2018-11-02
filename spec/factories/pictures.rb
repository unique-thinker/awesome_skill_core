# frozen_string_literal: true

FactoryBot.define do
  factory :picture do |_pic|
    sequence(:random_string) {|_n| SecureRandom.hex(10) }
    height { Faker::Number.between(40, 100) }
    width { Faker::Number.between(40, 60) }
    association :imageable, factory: :post
    processed_image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/jpeg') }

    after(:build, &:update_remote_path)
  end

  factory(:remote_photo, parent: :picture) do
    remote_image_path { Faker::Internet.url }
    remote_image_name { Faker::File.file_name }
    processed_image { nil }
  end
end
