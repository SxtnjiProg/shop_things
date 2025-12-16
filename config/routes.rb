Rails.application.routes.draw do
  get 'cart/index'
  # Devise для реєстрації/логіну (без конфліктів)
  devise_for :users

  # Каталог товарів (головна сторінка)
  root to: 'products#index'
  
  # ПОВНИЙ CRUD для адміністрування товарів
  resources :products 
  
  get '/cart', to: 'cart#index', as: :cart
  post '/cart/add/:id', to: 'cart#add', as: :add_to_cart
  patch '/cart/update/:id', to: 'cart#update_quantity', as: :update_cart_quantity
  delete '/cart/clear', to: 'cart#clear', as: :clear_cart
  
  # Відгуки nested під продуктами (для /products/:id/reviews)
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:create, :edit, :update, :destroy]
  end

  # Дефолт Rails (для Turbo/Stimulus, не чіпай)
  get '*path', to: 'application#fallback_index_html', constraints: ->(request) { request.xhr? }

  # New auth page (login + register panels)
  get '/auth', to: 'auth#index', as: :auth
end