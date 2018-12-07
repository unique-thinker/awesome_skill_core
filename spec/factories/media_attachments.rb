FactoryBot.define do
  factory :media_attachment do
    title { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    random_string { SecureRandom.hex(10) }
    kind { MediaAttachment.kinds.keys.sample }
    views_count { rand(1..100_000) }
    association :author, factory: :person
    association :attachable, factory: :post

    factory :image_attachment do
      after(:build) do |p|
        p.file.store! Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/jpeg'
        )
        p.update_remote_path
      end
    end

    factory :video_attachment do
      after(:build) do |p|
        p.file.store! Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures', 'video.mp4'), 'video/mp4'
        )
        p.update_remote_path
      end
    end
  end
end
