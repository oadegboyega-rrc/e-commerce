Rails.application.routes.draw do
  get "pages/about"
  get "pages/contact"
  get "products/index"
  get "products/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Customer-facing routes
  root to: "products#index"

  resources :products, only: [:index, :show] do
    collection do
      get :search
      get :category
    end
  end
  # Shopping cart routes
  resources :cart, only: [:index, :update, :destroy] do
    collection do
      post :add_item
      post :update_item
      post :remove_item
    end
  end

  # Static pages
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
end
