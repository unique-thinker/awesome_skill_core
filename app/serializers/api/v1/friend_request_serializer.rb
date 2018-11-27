# frozen_string_literal: true

class Api::V1::FriendRequestSerializer < Api::ApplicationSerializer
  attributes :confirmed, :created_at

  belongs_to :friend, serializer: :person do |obj, params|
    params[:current_user] == obj.user ? obj.friend : obj.user.person
  end
end
