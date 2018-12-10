# frozen_string_literal: true

module ActivityCallbacks
  extend ActiveSupport::Concern

  included do
    before_destroy :remove_activity
  end

  def remove_activity
    activity = PublicActivity::Activity.find_by(trackable: self, key: "#{self.class.to_s.downcase}.create")
    activity.destroy if activity.present?
    true
  end
end
