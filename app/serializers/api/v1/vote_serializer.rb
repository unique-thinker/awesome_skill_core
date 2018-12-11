# frozen_string_literal: true

class Api::V1::VoteSerializer < Api::ApplicationSerializer
  attributes :id, :guid, :created_at
  belongs_to :author, record_type: :person, serializer: :person
end
