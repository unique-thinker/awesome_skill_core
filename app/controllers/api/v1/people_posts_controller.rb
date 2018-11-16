# frozen_string_literal: true

class Api::V1::PeoplePostsController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    pictures = []
    post_params = normalize_params.merge!(user: current_user)
    normalize_params.delete(:image_files).each do |image_file|
      pic = PictureCreationService.call(post_params.slice(:public, :user).merge!(image_file: image_file))
      pictures << pic
    end
    post = PostManager::PeoplePostCreationService.call(post_params.merge(pictures: pictures))
    if post.save
      options = {include: [:pictures]}
      render json: Api::V1::PostSerializer.new(post, options), status: :created
    else
      render json: {success: false, errors: resource_errors(post)}, status: :unprocessable_entity
    end
  rescue AwesomeSkill::BadAspectsIDs
    render json:   {error: 'Provided aspects IDs aren\'t applicable (non-existent or not owned)'},
           status: :unprocessable_entity
  rescue StandardError => error
    handle_create_error(error)
  end

  def destroy
    begin
      destroy_post!(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to destroy post.'}, status: :not_found
      return
    end
    render json: {}, status: :no_content
  end

  def handle_create_error(error)
    logger.debug error
    render json: {error: error.message}, status: :forbidden
  end

  def normalize_params
    params.permit(
      post_message: [:text]
    ).to_h.merge(
      aspect_ids:  normalize_aspect_ids,
      public:      [*params[:aspect_ids]].first == 'public',
      image_files: [*params[:image_files]].compact
    )
  end

  def normalize_aspect_ids
    aspect_ids = [*params[:aspect_ids]]
    if aspect_ids.first == 'all_aspects'
      current_user.aspect_ids
    else
      aspect_ids
    end
  end
end
