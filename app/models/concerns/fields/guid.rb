# frozen_string_literal: true

module Fields
  module Guid
    extend ActiveSupport::Concern

    # Creates a after_initialize callback which calls #set_guid
    included do
      after_initialize :set_guid
      validates :guid, uniqueness: true
    end

    # @return [String] The model's guid.
    def set_guid
      self.guid = UUID.generate(:compact) if guid.blank?
    end
  end
end
