# frozen_string_literal: true

module EvilQuery
  extend ActiveSupport::Concern

  class Base
  end

  class VisibleShareableById < Base
    def initialize(user, klass, key, id, conditions={})
      @querent = user
      @class = klass
      @key = key
      @id  = id
      @conditions = conditions
    end

    def post!
      # small optimization - is this optimal order??
      querent_has_visibility.first || querent_is_author.first || public_post.first
    end

    protected

    def querent_has_visibility
      @class.where(@key => @id)
            .where(postable: @querent.person)
            .where(@conditions)
            .select(@class.table_name + '.*')
    end

    def querent_is_author
      @class.where(@key => @id, :postable => @querent.person).where(@conditions)
    end

    def public_post
      @class.where(@key => @id, :public => true).where(@conditions)
    end
  end
end
