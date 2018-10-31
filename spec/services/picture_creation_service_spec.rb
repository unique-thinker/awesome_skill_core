# frozen_string_literal: true

require 'rails_helper'

RSpec.describe :PictureCreationService, type: :service do
  let(:user) { create(:user) }
  let(:image_params) {
    {
      image_file: Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png'
      )
    }
  }

  describe '.call' do
    it 'returns the created Picture' do
      image = PictureCreationService.call(image_params.merge!(user: user))
      expect(image).to_not be_nil
      expect(image.guid).to_not be_nil
      expect(image.remote_image_path).to_not be_nil
      expect(image.remote_image_name).to_not be_nil
      expect(image.random_string).to_not be_nil
      expect(image.processed_image.url).to_not be_nil
    end

    context 'with public' do
      it 'it marks the photos as public' do
        image = PictureCreationService.call(image_params.merge!(user: user, public: true))
        expect(image.public).to be_truthy
      end
    end
  end
end
