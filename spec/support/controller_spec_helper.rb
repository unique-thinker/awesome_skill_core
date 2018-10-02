# frozen_string_literal: true

module ControllerSpecHelper
  def login(email, password)
    post user_session_path, params:  {
      email:    email,
      password: password
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
      'token_type'   => token_type
    }
    auth_params
  end

  # return invalid headers
  def invalid_headers(response)
    client = response.headers['client']
    token = 'invalid_token'
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client'       => client,
      'uid'          => uid,
      'expiry'       => expiry,
      'token_type'   => token_type
    }
    auth_params
  end
end
