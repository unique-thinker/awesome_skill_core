# frozen_string_literal: true

class Api::V1::CommentSerializer < Api::ApplicationSerializer
  attributes :id, :guid, :text, :created_at
  belongs_to :author, record_type: :person, serializer: :person
end
