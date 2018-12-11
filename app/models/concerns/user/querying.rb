# frozen_string_literal: true

module User::Querying
  extend ActiveSupport::Concern

  def find_visible_shareable_by_id(klass, id, opts={})
    key = (opts.delete(:key) || :id)
    ::EvilQuery::VisibleShareableById.new(self, klass, key, id, opts).post!
  end
end
