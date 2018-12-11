# frozen_string_literal: true

module Fields
  module Votable
    extend ActiveSupport::Concern

    included do
      has_many :likes, -> { where(positive: true, type: :Like) },
               class_name: 'Vote', inverse_of: :target,
               dependent: :delete_all, as: :target
      has_many :dislikes, -> { where(positive: false, type: :Dislike) },
               class_name: 'Vote', inverse_of: :target,
               dependent: :delete_all, as: :target
    end
  end
end
