# frozen_string_literal: true

class Api::V1::VideoSerializer < Api::ApplicationSerializer
  attributes :id, :guid, :created_at

  attribute :url do |vidoe|
    vidoe.processed_video.url
  end
end
