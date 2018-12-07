# frozen_string_literal: true

require 'rails_helper'

RSpec.describe :MediaAttachmentService, type: :service do
  let(:user) { create(:user) }
  let(:video_params) {
    {
      media_file: Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'video.mp4').to_s, 'video/mp4'
      )
    }
  }

  let(:image_params) {
    {
      media_file: Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/jpeg'
      )
    }
  }

  describe '.call' do
    it 'returns the Video attached instance' do
      media = MediaAttachmentService.call(video_params.merge!(user: user))
      expect(media).to_not be_nil
      expect(media.guid).to_not be_nil
      expect(media.remote_file_path).to_not be_nil
      expect(media.remote_file_name).to_not be_nil
      expect(media.random_string).to_not be_nil
      expect(media.file.url).to_not be_nil
    end

    it 'returns the Image attached instance' do
      media = MediaAttachmentService.call(image_params.merge!(user: user))
      expect(media).to_not be_nil
      expect(media.guid).to_not be_nil
      expect(media.remote_file_path).to_not be_nil
      expect(media.remote_file_name).to_not be_nil
      expect(media.random_string).to_not be_nil
      expect(media.file.url).to_not be_nil
    end

    context 'with public' do
      it 'it marks the video as public' do
        video = MediaAttachmentService.call(video_params.merge!(user: user, public: true))
        expect(video.public).to be_truthy
      end
    end
  end
end
