# frozen_string_literal: true

class Api::V1::PersonSerializer < Api::ApplicationSerializer
  attributes :id, :guid
end