# frozen_string_literal: true

class Video < ApplicationRecord
  include Fields::Author
  include Shareable

  # Association
  belongs_to :videoable, polymorphic: true

  mount_uploader :processed_video, ProcessedVideo

  def self.params_initialize(params={})
    video = new(params.to_hash.stringify_keys.slice(*column_names))
    video.random_string = SecureRandom.hex(10)

    if params[:video_file]
      video_file = params.delete(:video_file)
      video.processed_video.store! video_file
    end

    video.update_remote_path
    video
  end

  def update_remote_path
    remote_path = "#{ENV['BASE_URL']}#{processed_video.url}"

    name_start = remote_path.rindex '/'
    self.remote_video_path = "#{remote_path.slice(0, name_start)}/"
    self.remote_video_name = remote_path.slice(name_start + 1, remote_path.length)
  end

  def url(format=nil)
    uploaded_path = encode_path(file.path.sub(File.expand_path(root), ''))
    return uploaded_path if format.nil?

    files = Dir.entries(File.dirname(file.path))
    files.each do |f|
      next unless File.extname(f) == '.' + format.to_s

      return File.dirname(uploaded_path) + '/' + f
    end
  end
end
