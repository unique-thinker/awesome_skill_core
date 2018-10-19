# frozen_string_literal: true

class Api::V1::ProfilesController < Api::BaseController
  include Response

  before_action :authenticate_user!, except: %i[show]

  def edit
    person = current_user.person
    profile = person.profile
    render json: Api::V1::ProfileSerializer.new(profile), status: :ok
  end

  def update
    # upload and set new profile photo
    profile_attrs = profile_params
    profile = current_user.person.profile
    if profile.update(profile_attrs)
      head :no_content
    else
      render json: { success: false, errors: resource_errors(profile) }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(
      :first_name, :last_name, :birthday,
      :gender, :status, :bio, :professions,
      :company, :current_place, :native_place,
      :state, :country
    )
  end
end
