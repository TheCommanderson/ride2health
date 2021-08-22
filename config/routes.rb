# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  resources :sessions, only: %i[index new create] do
    collection do
      get 'about'
      get 'involved'
    end
  end

  resources :patients
end
