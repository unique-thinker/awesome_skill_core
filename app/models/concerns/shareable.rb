# frozen_string_literal: true

module Shareable
  extend ActiveSupport::Concern

  included do
    include Fields::Guid

    has_many :aspect_visibilities, as: :shareable, validate: false, dependent: :delete_all
    has_many :aspects, through: :aspect_visibilities
  end
end
