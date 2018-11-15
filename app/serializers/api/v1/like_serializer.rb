# frozen_string_literal: true

class Api::V1::LikeSerializer < Api::ApplicationSerializer
  attributes :id, :guid, :created_at
  belongs_to :author, record_type: :person, serializer: :person
end