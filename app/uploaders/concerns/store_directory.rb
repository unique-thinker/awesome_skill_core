# frozen_string_literal: true

module StoreDirectory
  extend ActiveSupport::Concern

  def store_dir
    "#{base_store_dir}/#{model.random_string[0..(model.random_string.size / 2)]}"
  end

  def base_store_dir
    "uploads/#{model.class.table_name}/#{model.guid[0..(model.guid.size / 2)]}"
  end

  def filename
    "#{model.random_string}.#{file.extension}" if original_filename.present?
  end
end
