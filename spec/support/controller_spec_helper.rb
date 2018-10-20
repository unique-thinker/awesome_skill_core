# frozen_string_literal: true

module ControllerSpecHelper
  def initialize(*)
    @accept = 'application/vnd.awesome-skill.v1+json'
  end

  def login(user)
    post '/auth/sign_in', params:  {
      email:    user.email,
      password: user.password
    }.to_json, headers: {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json'
    }
  end

  # return valid headers
  def valid_headers(response)
    client      = response.headers['client']
    token       = response.headers['access-token']
    expiry      = response.headers['expiry']
    token_type  = response.headers['token-type']
    uid         = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client'       => client,
      'uid'          => uid,
      'expiry'       => expiry,
      'token_type'   => token_type,
      'ACCEPT'       => @accept
    }
    auth_params
  end

  # return invalid headers
  def invalid_headers
    access_token = 'invalid access-token'
    client = 'invalid client'
    expiry = 'invalid expiry'
    token_type = 'invalid token_type'
    uid = 'invalid uid'

    auth_params = {
      'access-token' => access_token,
      'client'       => client,
      'uid'          => uid,
      'expiry'       => expiry,
      'token_type'   => token_type,
      'ACCEPT'       => @accept
    }
    auth_params
  end
end
