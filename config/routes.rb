Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :users
  constraints subdomain: "www" do
    get "/", to: "home#index"
  end
  get "/", to: "families#index"

  resources :families
  resources :searches
  resources :results, only: [:update]

  namespace :admin do
    authenticate :user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
