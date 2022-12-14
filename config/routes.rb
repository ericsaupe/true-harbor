Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :users
  constraints subdomain: "www" do
    get "/", to: "home#index"
  end
  get "/", to: "searches#index"

  resources :analytics, only: [:index] do
    collection do
      get :average_search_time
      get :average_no_per_search
      get :average_time_per_search
      get :average_yes_per_search
      get :search_types
      get :searches_by_created_at
    end
  end

  resources :families do
    member do
      put :contacted
    end

    resources :notes, only: [:new, :create]
  end
  resources :searches do
    member do
      put :complete
      get :download_results
      put :reopen
      get :results_table
      get :search_families
    end

    resources :results, only: [:create] do
      collection do
        delete "/destroy_by_family/:family_id", to: "results#destroy_by_family"
      end
    end
  end
  resources :results, only: [:update] do
    member do
      put :contacted
    end
  end

  namespace :admin do
    authenticate :user, ->(user) { user.admin? } do
      resources :child_needs
      resources :children
      resources :exclusions
      resources :families
      resources :imports, only: [:index, :new, :create]
      resources :notes
      resources :organizations
      resources :roles
      resources :regions
      resources :results
      resources :school_districts
      resources :searches
      resources :users

      root to: "searches#index"
    end

    authenticate :user, ->(user) { user.super_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
