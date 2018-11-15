# frozen_string_literal: true

class Api::V1::CommentsController < Api::BaseController
  include Response
  include PostConcern

  before_action :authenticate_user!

  def create
    begin
      post = find_post!(comment_params[:post_id])
      comment = current_user.comment!(post, comment_params[:comment][:text])
    rescue ActiveRecord::RecordNotFound
      render json: {success: false, error: 'Failed to comment.'}, status: :not_found
      return
    rescue ActiveRecord::RecordInvalid => invalid
      render json: {success: false, errors: resource_errors(invalid.record)}, status: :forbidden
      return
    end

    if comment
      options = {include: [:author]}
      render json: Api::V1::CommentSerializer.new(comment, options), status: :created
    else
      render json: {success: false, error: 'Failed to comment.'}, status: :unprocessable_entity
    end
  end

  def comment_params
    params.permit(:post_id, comment: %i[text])
  end
end
