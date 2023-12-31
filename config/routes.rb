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
      resource :profile, only: %i[edit update] do
        member do
          patch 'update_picture'
        end
      end

      resources :people, only: %i[show] do
        resources :people_posts, only: %i[create destroy]
      end

      resources :friendship_requests, only: %i[index create update destroy]

      post '/follow', to: 'relationships#follow', as: :follow
      delete '/unfollow', to: 'relationships#unfollow', as: :unfollow

      resources :posts, only: %i[show] do
        resources :comments, only: %i[create destroy]
        resources :likes, only: %i[create destroy]
        resources :dislikes, only: %i[create destroy]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
