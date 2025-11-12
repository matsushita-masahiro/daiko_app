Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#top"
  
  # SEO用ルート
  get "sitemap.xml" => "sitemaps#index", defaults: { format: :xml }
  get "robots.txt" => "sitemaps#robots", defaults: { format: :text }
  
  resources :inquiries, only: [:index, :show, :new, :create] do
    collection do
      post :confirm
      get :back_to_form
    end
    resources :answers, only: [:new, :create, :show]
  end
  
  # 位置情報記録用ルート
  post "user_location", to: "user_locations#create"
  
  # 管理者用ルート
  namespace :admin do
    root 'dashboard#index'
    resources :inquiries, only: [:index, :show] do
      resources :answers, only: [:new, :create]
    end
  end
end
