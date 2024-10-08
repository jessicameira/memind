Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :plan, only: :create

  get 'plan/:id', to: 'home#show_plan', as: :show_plan
  get 'about', to: 'home#about', as: :about
  get 'contact', to: 'home#contact', as: :contact
  get 'prices', to: 'home#prices', as: :prices
  get 'dashboard', to: 'plan#index', as: :dashboard
end
