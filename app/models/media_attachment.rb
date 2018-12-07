class MediaAttachment < ApplicationRecord
  include Fields::Author
  include Shareable

  # Association
  belongs_to :attachable, polymorphic: true
  
  # ENUM
  enum kind: {video: 'video', image: 'image'}

  mount_uploader :file, MediaUploader

  def self.params_initialize(params={})
    media = new(params.to_hash.stringify_keys.slice(*column_names))
    media.random_string = SecureRandom.hex(10)

    if params[:media_file]
      media_file = params.delete(:media_file)
      media.file.store! media_file
    elsif params[:media_url]
      media.remote_file_url = params[:image_url]
      media.file.store!
    end

    media.update_remote_path
    media
  end

  def update_remote_path
    remote_path = if file.url =~ %r{^https?:\/\/}
                    file.url
                  else
                    "#{ENV['BASE_URL']}#{file.url}"
                  end

    name_start = remote_path.rindex '/'
    self.remote_file_path = "#{remote_path.slice(0, name_start)}/"
    self.remote_file_name = remote_path.slice(name_start + 1, remote_path.length)
  end
end
