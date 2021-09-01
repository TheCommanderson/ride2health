# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  # KEEP SORTED #
  resources :admins
  resources :appointments do
    resources :locations, only: %i[edit]
  end
  resources :drivers do
    member do
      post 'approve'
    end
  end
  resources :healthcareadmins
  resources :patients do
    resources :locations
    resources :comments
    member do
      get 'appointments'
      post 'approve'
    end
  end
  resources :sessions, only: %i[index new create] do
    collection do
      get 'about'
      get 'involved'
      delete 'logout'
    end
  end
  resources :users, only: %i[show edit] do
    member do
      get 'password'
      patch 'submit'
    end
  end
  resources :volunteers
end
