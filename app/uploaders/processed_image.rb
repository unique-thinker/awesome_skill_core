# frozen_string_literal: true

class ProcessedImage < ImageUploader
  after :remove, :delete_empty_upstream_dirs

  def store_dir
    "#{base_store_dir}/#{model.random_string[0..5]}"
  end

  def base_store_dir
    "uploads/#{model.guid}"
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
      img.format('png') do |c|
        c.fuzz '3%'
        c.trim
        c.resize      "#{width}x#{height}>"
        c.resize      "#{width}x#{height}<"
      end
      img
    end
  end

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path) # fails if path not empty dir

    path = ::File.expand_path(base_store_dir, root)
    Dir.delete(path) # fails if path not empty dir
  rescue SystemCallError
    true # nothing, the dir is not empty
  end
end
