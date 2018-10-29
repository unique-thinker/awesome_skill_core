# frozen_string_literal: true

class ProcessedImage < ImageUploader

  def store_dir
    'uploads/images'
  end

  def filename
    model.random_string + File.extname(@filename) if @filename
  end

  version :thumb_small do
    process efficient_conversion: [50, 50]
  end
  version :thumb_medium do
    process efficient_conversion: [100, 100]
  end
  version :thumb_large do
    process efficient_conversion: [300, 1500]
  end
  version :scaled_full do
    process efficient_conversion: [700, nil]
  end

  private
  def efficient_conversion(width, height)
    manipulate! do |img|
      img.format("png") do |c|
        c.fuzz        "3%"
        c.trim
        c.resize      "#{width}x#{height}>"
        c.resize      "#{width}x#{height}<"
      end
      img
    end
  end
end
