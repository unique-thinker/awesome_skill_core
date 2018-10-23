# frozen_string_literal: true

module Fields
  module Author
    extend ActiveSupport::Concern

    def self.included(model)
      model.class_eval do
        belongs_to :author, class_name: "Person"

        delegate :diaspora_handle, to: :author

        validates :author, presence: true
      end
    end
  end
end
