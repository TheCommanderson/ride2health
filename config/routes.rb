# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  # KEEP SORTED #
  resources :admins
  resources :drivers
  resources :healthcareadmins
  resources :patients
  resources :sessions, only: %i[index new create] do
    collection do
      get 'about'
      get 'involved'
      delete 'logout'
    end
  end
  resources :volunteers
end
