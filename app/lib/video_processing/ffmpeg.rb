# frozen_string_literal: true

module VideoProcessing
  module FFMPEG
    extend ActiveSupport::Concern

    module ClassMethods
      def encode_video(target_format)
        process encode_video: [target_format]
      end
    end

    def encode_video(format)
      directory = File.dirname(current_path)
      tmp_path = File.join(directory, "tmpfile.#{format}")
      File.rename(current_path, tmp_path)

      encoder_initialize(tmp_path)
      new_name = model.random_string + '.' + format.to_s
      current_extenstion = File.extname(current_path).delete('.')
      encoded_path = File.join(directory, new_name)

      @video.transcode(encoded_path)

      # warning: magic!
      # change format for uploaded file name and store file format
      # without this lines processed video files will remain in cache folder
      file.file[-current_extenstion.size..-1] = format.to_s

      File.rename encoded_path, current_path
    end

    def store_dimensions
      return unless file && model && encoder_initialize(file.file)

      model.width = @video.width
      model.height = @video.height
    end

    def store_duration
      model.duration = @video.duration if file && model && encoder_initialize(file.file)
    end

    def encoder_initialize(path)
      @video = ::FFMPEG::Movie.new(path)
    end
  end
end
