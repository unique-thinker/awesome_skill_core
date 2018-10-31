# frozen_string_literal: true

class Api::V1::PictureSerializer < Api::ApplicationSerializer
  # belongs_to :imageable, polymorphic: true

  attributes :id, :guid, :created_at

  attribute :small do |pic|
    pic.processed_image.url(:thumb_small)
  end

  attribute :medium do |pic|
    pic.processed_image.url(:thumb_medium)
  end

  attribute :large do |pic|
    pic.processed_image.url(:scaled_full)
  end
end
