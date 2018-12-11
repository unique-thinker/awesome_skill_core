# frozen_string_literal: true

class Api::V1::DislikesController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    begin
      post = find_post!(dislike_params[:post_id])
      post.likes.find_by(author: current_user)&.destroy
      dislike = current_user.dislike!(post)
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to dislike.'}, status: :not_found
      return
    end

    if dislike
      options = {include: [:author]}
      render json: Api::V1::VoteSerializer.new(dislike, options), status: :created
    else
      render json: {success: false, error: 'Failed to dislike.'}, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      dislike = Dislike.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to remove dislike.'}, status: :not_found
      return
    end
    if current_user.owns?(dislike) && dislike.destroy
      render json: {}, status: :no_content
    else
      render json: {}, status: :forbidden
    end
  end

  def dislike_params
    params.permit(:post_id)
  end
end
