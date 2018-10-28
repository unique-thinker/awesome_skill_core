# frozen_string_literal: true

class Api::V1::PeoplePostsController < Api::BaseController
  include Response

  before_action :authenticate_user!

  def create
    pictures = []
    post_params = normalize_params.merge!({user: current_user})
    normalize_params.delete(:image_files).each do |image_file|
      pic = PictureCreationService.call({ image_file: image_file })
      pictures << pic
    end
    post = PostManager::PeoplePostCreationService.call(post_params.merge(pictures: pictures))
    if post.save
    else
      render json: {success: false, errors: resource_errors(post)}, status: :unprocessable_entity
    end
    #binding.pry
  end

  def normalize_params
    params.permit(
      post_message: [:text],
    ).to_h.merge(
        aspect_ids:        normalize_aspect_ids,
        public:            [*params[:aspect_ids]].first == "public",
        image_files: [*params[:image_files]].compact
    )
  end

  def normalize_aspect_ids
    aspect_ids = [*params[:aspect_ids]]
    if aspect_ids.first == "all_aspects"
      current_user.aspect_ids
    else
      aspect_ids
    end
  end
end
