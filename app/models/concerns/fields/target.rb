# frozen_string_literal: true

module Fields
  module Target
    extend ActiveSupport::Concern

    included do
      belongs_to :target, polymorphic: true

      validates :target_id, uniqueness: {scope: %i[target_type author_id]}
    end
  end
end
