# frozen_string_literal: true

class Vote < ApplicationRecord
  include Fields::Guid
  include Fields::Author
  include Fields::Target
  # Activity
  include ActivityCallbacks
  include PublicActivity::Model
  tracked only: [:create], owner: proc {|controller, _model| controller && controller.current_user }

  alias_attribute :parent, :target
end
