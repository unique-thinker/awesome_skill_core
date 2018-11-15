# frozen_string_literal: true

class Vote < ApplicationRecord
  include Fields::Guid
  include Fields::Author
  include Fields::Target

  alias_attribute :parent, :target
end
