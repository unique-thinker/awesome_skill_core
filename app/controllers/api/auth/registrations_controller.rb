# frozen_string_literal: true

class Api::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      resource.seed_aspects if resource.persisted?
    end
  end

  def build_resource
    @resource            = resource_class.build(sign_up_params)
    @resource.provider   = provider
    @resource.set_person

    # honor devise configuration for case_insensitive_keys
    @resource.email = if resource_class.case_insensitive_keys.include?(:email)
                        sign_up_params[:email].try(:downcase)
                      else
                        sign_up_params[:email]
                      end
  end
end
