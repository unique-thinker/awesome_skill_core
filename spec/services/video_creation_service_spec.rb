# frozen_string_literal: true

require 'rails_helper'

RSpec.describe :VideoCreationService, type: :service do
  let(:user) { create(:user) }
  let(:video_params) {
    {
      video_file: Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'video.mp4').to_s, 'video/mp4'
      )
    }
  }

  describe '.call' do
    it 'returns the Video instance' do
      video = VideoCreationService.call(video_params.merge!(user: user))
      expect(video).to_not be_nil
      expect(video.guid).to_not be_nil
      expect(video.remote_video_path).to_not be_nil
      expect(video.remote_video_name).to_not be_nil
      expect(video.random_string).to_not be_nil
      expect(video.processed_video.url).to_not be_nil
    end

    context 'with public' do
      it 'it marks the video as public' do
        video = VideoCreationService.call(video_params.merge!(user: user, public: true))
        expect(video.public).to be_truthy
      end
    end
  end
end
