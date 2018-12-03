# frozen_string_literal: true

class ProcessedVideo < VideoUploader
  include StoreDirectory

  process :store_dimensions
  process :store_duration

  # version :mp4 do
  #   process encode_video: [:mp4]
  # end

  # version :webm do
  #   process encode_video: [:webm]
  # end
end