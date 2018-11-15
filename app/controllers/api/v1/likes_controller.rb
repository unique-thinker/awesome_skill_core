# frozen_string_literal: true

class Api::V1::LikesController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    begin
      post = find_post!(like_params[:post_id])
      like = current_user.like!(post)
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to like.'}, status: 404
      return
    end

    if like
      options = {include: [:author]}
      render json: LikeSerializer.new(like, options), status: 201
    else
      render json: {success: false, error: 'Failed to like.'}, status: 422
    end
  end

  def like_params
    params.permit(:post_id)
  end
end