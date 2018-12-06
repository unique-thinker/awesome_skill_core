# frozen_string_literal: true

class VideoCreationService < ApplicationService
  def initialize(*args)
    @params = args.first
    @user = @params.delete(:user)
  end

  def call
    rescuing_image_errors do
      legacy_create(@params)
    end
  end

  private

  attr_reader :user

  def legacy_create(video_params)
    public = video_params[:public] || false
    @video = user.build_post(:video, video_params.merge(public: public, author_id: user.person.id))
  end

  def rescuing_image_errors
    yield
  rescue TypeError
    return_image_error 'Video upload failed. Are you sure an video was added?'
  rescue CarrierWave::IntegrityError
    return_image_error 'Video upload failed. Are you sure that was an video?'
  rescue RuntimeError
    return_image_error 'Video upload failed. Are you sure that your seatbelt is fastened?'
  end

  def return_image_error(message)
    render json: {error: message}
  end
end
