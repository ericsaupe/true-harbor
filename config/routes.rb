Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :users
  authenticated :user do
    root to: 'families#index', as: :authenticated_root
  end

  root "home#index"

  resources :families

  namespace :admin do
    authenticate :user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
