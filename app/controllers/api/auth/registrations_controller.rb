# frozen_string_literal: true

class Api::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super
    # binding.pry
  end
end
