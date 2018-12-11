# frozen_string_literal: true

module AwesomeSkill
  class Generator
    def initialize(user, target)
      @user = user
      @target = target
    end

    def create!(options={})
      relayable = build(options)
      relayable if relayable.save!
    end

    def build(options={})
      self.class.federated_class.new(options.merge(relayable_options).merge(author_id: @user.person.id))
    end

    protected

    def relayable_options
      raise NotImplementedError, 'You must override relayable_options'
    end
  end
end
