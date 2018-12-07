# frozen_string_literal: true

class Api::V1::MediaAttachmentSerializer < Api::ApplicationSerializer
  attributes :id, :guid, :created_at

  # attribute :url do |media|
  #   media.file.url
  # end

  # attribute :small do |media|
  #   media.file.url(:thumb_small)
  # end

  # attribute :medium do |pic|
  #   media.file.url(:thumb_medium)
  # end

  # attribute :large do |pic|
  #   media.file.url(:scaled_full)
  # end
end
