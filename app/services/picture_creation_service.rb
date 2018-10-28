class PictureCreationService < ApplicationService
  def initialize(*args, &block)
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

  def legacy_create(image_params)
    image_params[:image_file] = file_handler(image_params)
    @image = user.build_post(:picture, image_params)
  end

  def file_handler(params)
    image_file = params[:image_file] if !params[:images_file].is_a?(String)
  end

  def rescuing_image_errors
    yield
  rescue TypeError
    return_image_error 'Photo upload failed. Are you sure an image was added?'
  rescue CarrierWave::IntegrityError
    return_image_error 'Photo upload failed. Are you sure that was an image?'
  rescue RuntimeError
    return_image_error 'Photo upload failed. Are you sure that your seatbelt is fastened?'
  end

  def return_image_error(message)
    render json: { error: message }
  end
end
