# frozen_string_literal: true

class Api::V1::FriendshipsController < Api::BaseController
  include Response

  before_action :authenticate_user!
  before_action :find_friend, only: %i[create update destroy]

  def index
    @incoming = Friendship.where(friend: current_user.person, confirmed: false)
    @outgoing = current_user.friendships.where(confirmed: false)
  end

  def create
    return render json: {success: false, error: 'Failed to send friend request.'}, status: :not_found if @not_found
    if current_user.send_friend_request(@friend)
      render json: {}, status: :created
    else
      render json: {errors: 'Failed to send friend request.'}, status: :unprocessable_entity
    end
  end

  def update
    return render json: {success: false, error: 'Failed to accept friend request.'}, status: :not_found if @not_found
    if current_user.accept_friend_request(@friend)
      render json: {}, status: :no_content
    else
      render json: {error: 'Failed to accept friend request.'}, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: {success: false, error: 'Failed to unfriend.'}, status: :not_found if @not_found
    if current_user.unfriend(@friend)
      render json: {}, status: :no_content
    else
      render json: {error: 'Failed to unfriend.'}, status: :unprocessable_entity
    end
  end

  def find_friend
    @friend = Person.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @not_found = e
  end
end
