class Dislike < Vote
  class Generator < AwesomeSkill::Generator
    def self.federated_class
      Dislike
    end

    def relayable_options
      {:target => @target, :positive => false}
    end
  end
end
