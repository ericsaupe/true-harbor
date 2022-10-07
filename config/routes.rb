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
    authenticate :user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
