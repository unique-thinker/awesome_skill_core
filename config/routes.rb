# frozen_string_literal: true

Rails.application.routes.draw do
  # namespace the controllers without affecting the URI
  scope module: :api, defaults: {format: :json}, path: '/' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      # confirmations:      'devise_token_auth/confirmations',
      # passwords:          'devise_token_auth/passwords',
      # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
      registrations: 'api/auth/registrations',
      # sessions:           'devise_token_auth/sessions',
      # token_validations:  'devise_token_auth/token_validations'
    }, skip: [:omniauth_callbacks]

    scope module: :v1, constraints: ApiVersionConstraint.new('v1', false) do
      resource :profile, only: %i[edit update]
      resources :people, only: %(show) do
        resources :people_posts, only: %(create)
      end
      resources :posts, only: %i(show destroy) do
        resources :comments, only: %i[create destroy]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
