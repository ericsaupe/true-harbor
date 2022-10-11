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
      mount Sidekiq::Web => "/sidekiq"
    end

    resources :families
    resources :organizations
    resources :results
    resources :roles
    resources :searches
    resources :users
  end
end
