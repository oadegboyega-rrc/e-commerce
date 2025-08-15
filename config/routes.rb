## removed duplicate routes block
Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  get "orders/index"
  get "orders/show"
  get "checkout/show"
  get "checkout/address"
  get "checkout/review"
  get "checkout/complete"
  devise_for :users
  get "privacy", to: "pages#privacy", as: :privacy_policy
  get "terms", to: "pages#terms", as: :terms_of_service
  get "pages/about"
  get "pages/contact"
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
  resource :cart, only: [:show, :update, :destroy] do
    collection do
      post :add_item
      post :update_item
      post :remove_item
    end
  end

  # Checkout routes (Feature 3.1.3 ✯)
  resources :checkout, only: [:show, :create] do
    collection do
      get :address
      post :process_address
      get :review
      post :complete
    end
  end
  
  # User profile and orders (Feature 3.2.1)
  resources :orders, only: [:index, :show]
  resource :profile, only: [:show, :edit, :update]
  
  # Static pages
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'


  # Static pages
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
end
