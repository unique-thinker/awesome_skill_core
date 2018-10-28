FactoryBot.define do
  factory :picture do |pic|
    sequence(:random_string) {|n| SecureRandom.hex(10) }
    height { Faker::Number.between(40, 100) }
    width { Faker::Number.between(40, 60) }
    pic.imageable { |p| p.association(:post) }
    processed_image { Rack::Test::UploadedFile.new(Rails.root.join($fixtures_dir, 'picture.png'), 'image/jpeg') }

    after(:build) do |p|
      # p.processed_image.store! File.open(File.join($fixtures_dir, 'picture.png'))
      p.update_remote_path
    end
  end

  factory(:remote_photo, :parent => :picture) do
    remote_image_path { Faker::Internet.url }
    remote_image_name { Faker::File.file_name }
    processed_image { nil }
  end
end
