# frozen_string_literal: true

class MediaAttachmentService < ApplicationService
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

  def legacy_create(media_params)
    public = media_params[:public] || false
    @media = user.build_post(:media_attachment, media_params.merge(public: public, author_id: user.person.id))
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
