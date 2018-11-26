# frozen_string_literal: true

module ControllerSpecHelper
  def login(user)
    post '/auth/sign_in', params:  {
      email:    user.email,
      password: user.password
    }.to_json, headers: headers
  end

  def guid
    UUID.generate(:compact)
  end
end
