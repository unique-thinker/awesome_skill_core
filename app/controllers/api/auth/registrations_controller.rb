# frozen_string_literal: true

class Api::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
    end
  end

  def build_resource
    @resource            = resource_class.build(sign_up_params)
    @resource.provider   = provider
    @resource.set_person

    # honor devise configuration for case_insensitive_keys
    if resource_class.case_insensitive_keys.include?(:email)
    @resource.email = sign_up_params[:email].try(:downcase)
    else
    @resource.email = sign_up_params[:email]
  end
  end
end
