# frozen_string_literal: true

class ApplicationController < ActionController::API
  include PublicActivity::StoreController

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username email password password_confirmation])

    devise_parameter_sanitizer.permit(:sign_in,
                                      keys: %i[email password])
  end
end
