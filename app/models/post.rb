# frozen_string_literal: true

class Post < ApplicationRecord
  include Fields::Guid
  include Fields::Author
  # Association
  # belongs_to :auther, class_name: 'Person'

  def self.params_initialize(params)
    new(params.to_hash.stringify_keys.slice(*column_names, 'author'))
  end
end
