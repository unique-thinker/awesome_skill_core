# frozen_string_literal: true

module User::SocialActions
  def comment!(target, text, opts={})
    Comment::Generator.new(self, target, text).create!(opts)
  end

  def like!(target, opts={})
    Like::Generator.new(self, target).create!(opts)
  end

  def dislike!(target, opts={})
    Dislike::Generator.new(self, target).create!(opts)
  end
end
