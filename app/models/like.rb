# frozen_string_literal: true

class Like < Vote
  class Generator < AwesomeSkill::Generator
    def self.federated_class
      Like
    end

    def relayable_options
      {target: @target, positive: true}
    end
  end
end
