# frozen_string_literal: true

class AspectVisibility < ApplicationRecord
  belongs_to :aspect
  belongs_to :shareable, polymorphic: true

  validates :aspect, uniqueness: {scope: %i[shareable_id shareable_type]}
end
