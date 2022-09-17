Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root to: 'families#index', as: :authenticated_root
  end

  root "home#index"

  resources :families
end
