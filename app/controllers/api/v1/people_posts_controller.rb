# frozen_string_literal: true

class Api::V1::PeoplePostsController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    post_params = normalize_params.merge!(user: current_user)
    pictures = store_pictures(post_params)
    videos = store_videos(post_params)
    post = PostManager::PeoplePostCreationService.call(post_params.merge(pictures: pictures, videos: videos))
    store_post_categories(normalize_params[:category_ids], post)

    if post.save
      options = {include: [:pictures, :videos]}
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

  private
  def normalize_params
    params.permit(
      post_message: [:text]
    ).to_h.merge(
      aspect_ids:  normalize_aspect_ids,
      category_ids: normalize_category_ids,
      public:      [*params[:aspect_ids]].first == 'public',
      image_files: [*params[:image_files]].compact,
      video_files: [*params[:video_files]].compact
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

  def normalize_category_ids
    category_ids = [*params[:category_ids]]
    if [*params[:aspect_ids]].first == 'public'
      category_ids
    else
      []
    end
  end

  def store_pictures(post_params)
    pictures = []
    return pictures if post_params[:image_files].empty?
    post_params.delete(:image_files).each do |image_file|
      pic = PictureCreationService.call(post_params.slice(:public, :user).merge!(image_file: image_file))
      pictures << pic
    end
    pictures
  end

  def store_videos(post_params)
    videos = []
    return videos if post_params[:video_files].empty?
    post_params.delete(:video_files).each do |video_file|
      video = VideoCreationService.call(post_params.slice(:public, :user).merge!(video_file: video_file))
      videos << video
    end
    videos
  end

  def store_post_categories(category_ids, post)
    return if category_ids.empty?
    if !post.pictures.empty?
      category_ids.each do |id|
        pic_category = Category.picture.find(id)
        post.categorizations.build(category: pic_category)
      end
    elsif !post.videos.empty?
      category_ids.each do |id|
        video_category = Category.video.find(id)
        post.categorizations.build(category: video_category)
      end
    end
    rescue ActiveRecord::RecordNotFound => e
  end
end
