# frozen_string_literal: true

module User::SocialActions
  def comment!(target, text, opts={})
    Comment::Generator.new(self, target, text).create!(opts)
  end
end
