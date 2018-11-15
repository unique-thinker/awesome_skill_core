# frozen_string_literal: true

class Api::V1::DislikesController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    begin
      post = find_post!(dislike_params[:post_id])
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

  def dislike_params
    params.permit(:post_id)
  end
end
