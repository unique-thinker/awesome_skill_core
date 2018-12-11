# frozen_string_literal: true

def build_attributes(*args)
  FactoryBot.build(*args).attributes.with_indifferent_access.delete_if do |k, _v|
    %w[id created_at updated_at].member?(k)
  end
end
