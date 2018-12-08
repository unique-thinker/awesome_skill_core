# frozen_string_literal: true

class MediaUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include VideoProcessing::FFMPEG

  process :check_file_type
  process :file_meta
  process :save_content_type_and_size_in_model

  IMAGE_FILE_EXTENSIONS = %w[jpg jpeg png gif].freeze
  VIDEO_FILE_EXTENSIONS = %w[webm mp4 m4v mov].freeze

  IMAGE_MIME_TYPES = %w[image/jpeg image/png image/gif].freeze
  VIDEO_MIME_TYPES = %w[video/webm video/mp4 video/quicktime].freeze

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{base_store_dir}/#{model.random_string[0..(model.random_string.size / 2)]}"
  end

  def base_store_dir
    "uploads/#{model.type}/#{model.guid[0..(model.guid.size / 2)]}"
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.random_string}.#{file.extension}" if original_filename.present?
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    IMAGE_FILE_EXTENSIONS + VIDEO_FILE_EXTENSIONS
  end

  # Create different versions of your uploaded files:
  # version :mp4, if: :video? do
  #   process encode_video: [:mp4]
  # end

  # version :webm, if: :video? do
  #   process encode_video: [:webm]
  # end

  version :thumb_small, if: :image? do
    process efficient_conversion: [50, 50]
  end
  version :thumb_medium, if: :image? do
    process efficient_conversion: [100, 100]
  end
  version :thumb_large, if: :image? do
    process efficient_conversion: [300, 1500]
  end
  version :scaled_full, if: :image? do
    process efficient_conversion: [700, nil]
  end

  def check_file_type
    @image = IMAGE_MIME_TYPES.include? file.content_type
    @video = VIDEO_MIME_TYPES.include? file.content_type
  end

  def save_content_type_and_size_in_model
    if file.content_type
      model.content_type = file.content_type
      model.type = file.content_type.split('/').first.to_sym
    end
    model.size = file.size
  end

  def file_meta
    if @image
      img = ::MiniMagick::Image.open(file.file)

      return {} unless img.valid?

      model.file_meta = {
        width:  img.width,
        height: img.height
      }
    elsif @video
      movie = ::FFMPEG::Movie.new(file.file)

      return {} unless movie.valid?

      model.file_meta = {
        width:      movie.width,
        height:     movie.height,
        frame_rate: movie.frame_rate,
        duration:   movie.duration,
        bitrate:    movie.bitrate
      }
    end
  end

  def image?(new_file)
    new_file.content_type.include? 'image'
  end

  def video?(new_file)
    new_file.content_type.include? 'video'
  end

  private

  def efficient_conversion(width, height)
    manipulate! do |img|
      img.format('png') do |c|
        c.fuzz '3%'
        c.trim
        c.resize      "#{width}x#{height}>"
        c.resize      "#{width}x#{height}<"
      end
      img
    end
  end
end
