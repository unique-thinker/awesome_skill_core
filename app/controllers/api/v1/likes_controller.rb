# frozen_string_literal: true

class Api::V1::LikesController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    begin
      post = find_post!(like_params[:post_id])
      post.dislikes.find_by(author: current_user)&.destroy
      like = current_user.like!(post)
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to like.'}, status: :not_found
      return
    end

    if like
      options = {include: [:author]}
      render json: Api::V1::VoteSerializer.new(like, options), status: :created
    else
      render json: {success: false, error: 'Failed to like.'}, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      like = Like.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to unlike.'}, status: :not_found
      return
    end
    if current_user.owns?(like) && like.destroy
      render json: {}, status: :no_content
    else
      render json: {}, status: :forbidden
    end
  end

  def like_params
    params.permit(:post_id)
  end
end
