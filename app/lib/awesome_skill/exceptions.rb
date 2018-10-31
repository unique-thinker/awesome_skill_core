# frozen_string_literal: true

module AwesomeSkill
  # Generic Awesome Skill exception class.
  class AwesomeSkillError < StandardError; end

  class BadAspectsIDs < AwesomeSkillError; end
end