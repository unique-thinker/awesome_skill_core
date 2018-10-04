# frozen_string_literal: true

class Api::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
end
