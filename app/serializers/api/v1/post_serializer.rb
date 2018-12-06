# frozen_string_literal: true

class Api::V1::PostSerializer < Api::ApplicationSerializer
  attributes :public, :guid, :text, :postable_id, :postable_type, :created_at
  has_many :pictures, as: :imageable, if: proc {|post| post.pictures.any? }
  has_many :videos, as: :videoable, if: proc {|post| post.videos.any? }
end
