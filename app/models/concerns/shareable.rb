# frozen_string_literal: true

module Shareable
  def self.included(model)
    model.instance_eval do
      include Fields::Guid

      has_many :aspect_visibilities, as: :shareable, validate: false, dependent: :delete_all
      has_many :aspects, through: :aspect_visibilities

      # has_many :share_visibilities, as: :shareable, dependent: :delete_all
    end
  end
end
