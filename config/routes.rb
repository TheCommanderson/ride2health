# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  # KEEP SORTED #
  resources :admins
  resources :appointments
  resources :drivers do
    member do
      post 'approval'
    end
  end
  resources :healthcareadmins
  resources :patients do
    member do
      get 'comment'
      post 'comment'
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
      patch 'password'
    end
  end
  resources :volunteers
end
