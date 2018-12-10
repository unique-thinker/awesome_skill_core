# frozen_string_literal: true

PublicActivity::Activity.class_eval do
  include Fields::Guid
end
