# frozen_string_literal: true

class StatusMessage < Post
  # Validations
  validates :text, length: {maximum: 65_535}

  # don't allow creation of empty status messages
  validate :presence_of_content, on: :create

  private

  def text_and_photos_blank?
    text.blank?
  end

  def presence_of_content
    errors[:base] << 'Cannot create a StatusMessage without content' if text_and_photos_blank?
  end
end
