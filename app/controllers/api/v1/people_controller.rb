# frozen_string_literal: true

class Api::V1::PeopleController < Api::BaseController
  before_action :authenticate_user!, except: %i[show]
end
