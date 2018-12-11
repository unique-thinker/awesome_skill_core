# frozen_string_literal: true

class Api::V1::PostSerializer < Api::ApplicationSerializer
  attributes :public, :guid, :text, :postable_id, :postable_type, :created_at
  has_many :attachments, as:         :attachable,
                         serializer: Api::V1::MediaAttachmentSerializer,
                         if:         proc {|post| post.attachments.any? }
end
