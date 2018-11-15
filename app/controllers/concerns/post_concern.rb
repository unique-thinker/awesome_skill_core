# frozen_string_literal: true

module PostConcern
  extend ActiveSupport::Concern

  def find_post!(id_or_guid)
    if current_user
      find_non_public_by_guid_or_id_with_user!(id_or_guid)
    else
      find_public!(id_or_guid)
    end
  end

  private

  def find_public!(id_or_guid)
    Post.where(post_key(id_or_guid) => id_or_guid).first.tap do |post|
      unless post
        raise ActiveRecord::RecordNotFound,
              "could not find a post with id #{id_or_guid}"
      end
      raise AwesomeSkill::NonPublic unless post.public?
    end
  end

  def find_non_public_by_guid_or_id_with_user!(id_or_guid)
    current_user.find_visible_shareable_by_id(Post, id_or_guid, key: post_key(id_or_guid)).tap do |post|
      unless post
        raise ActiveRecord::RecordNotFound,
              "could not find a post with id #{id_or_guid} for user #{current_user.id}"
      end
    end
  end

  # We can assume a guid is at least 16 characters long as we have guids set to hex(8) since we started using them.
  def post_key(id_or_guid)
    id_or_guid.to_s.length < 16 ? :id : :guid
  end
end
