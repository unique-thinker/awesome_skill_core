# frozen_string_literal: true

module AwesomeSkill
  # Generic Awesome Skill exception class.
  class AwesomeSkillError < StandardError; end

  class BadAspectsIDs < AwesomeSkillError; end

  class NotImplementedError < AwesomeSkillError; end

  # the post in question is not public, and that is somehow a problem
  class NonPublic < AwesomeSkillError; end

  # something that should be accessed does not belong to the current user and
  # that prevents further execution
  class NotMine < AwesomeSkillError; end
end
