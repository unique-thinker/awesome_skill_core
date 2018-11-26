# frozen_string_literal: true

class Api::V1::RelationshipsController < Api::BaseController
  include Response

  before_action :authenticate_user!
  before_action :find_person, only: %i[follow unfollow]

  def follow
    if current_user.follow(@person)
      render json: {}, status: :created
    else
      render json: {errors: 'Failed to follow.'}, status: :unprocessable_entity
    end
  end

  def unfollow
    if current_user.unfollow(@person)
      render json: {}, status: :no_content
    else
      render json: {errors: 'Failed to unfollow.'}, status: :unprocessable_entity
    end
  end

  private
  def find_person
    @person = Person.find_by(guid: params[:guid])
  end
end
