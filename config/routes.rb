# frozen_string_literal: true

Rails.application.routes.draw do
  # namespace the controllers without affecting the URI
  namespace :api, defaults: {format: :json}, path: '/', as: '' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      # confirmations:      'devise_token_auth/confirmations',
      # passwords:          'devise_token_auth/passwords',
      # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
      registrations: 'api/auth/registrations',
      # sessions:           'devise_token_auth/sessions',
      # token_validations:  'devise_token_auth/token_validations'
    }, skip: [:omniauth_callbacks]
    scope module: :v1, constraints: ApiVersionConstraint.new('v1', true) do
      # resources :todos
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
