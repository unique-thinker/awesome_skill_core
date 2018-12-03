# frozen_string_literal: true

class Picture < ApplicationRecord
  include Fields::Author
  include Shareable

  # Association
  belongs_to :imageable, polymorphic: true

  mount_uploader :processed_image, ProcessedImage

  def self.params_initialize(params={})
    picture = new(params.to_hash.stringify_keys.slice(*column_names))
    picture.random_string = SecureRandom.hex(10)

    if params[:image_file]
      image_file = params.delete(:image_file)
      picture.processed_image.store! image_file
    elsif params[:image_url]
      picture.remote_processed_image_url = params[:image_url]
      picture.processed_image.store!
    end

    picture.update_remote_path

    picture
  end

  def update_remote_path
    remote_path = if processed_image.url =~ %r{^https?:\/\/}
                    processed_image.url
                  else
                    "#{ENV['BASE_URL']}#{processed_image.url}"
                  end

    name_start = remote_path.rindex '/'
    self.remote_image_path = "#{remote_path.slice(0, name_start)}/"
    self.remote_image_name = remote_path.slice(name_start + 1, remote_path.length)
  end
end
