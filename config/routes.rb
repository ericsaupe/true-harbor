Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :users
  constraints subdomain: "www" do
    get "/", to: "home#index"
  end
  get "/", to: "searches#index"

  resources :families do
    member do
      put :contacted
    end

    resources :notes, only: [:new, :create]
  end
  resources :searches do
    member do
      put :complete
      put :reopen
      get :download_results
    end
  end
  resources :results, only: [:update] do
  end

  namespace :admin do
    authenticate :user, ->(user) { user.admin? } do
      resources :searches
      resources :roles
      resources :results
      resources :organizations
      resources :notes
      resources :families
      resources :exclusions
      resources :children
      resources :users

      root to: "searches#index"
    end

    authenticate :user, ->(user) { user.super_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
