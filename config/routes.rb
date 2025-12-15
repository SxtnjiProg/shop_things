Rails.application.routes.draw do
  get 'cart/index'
  # Devise для реєстрації/логіну (без конфліктів)
  devise_for :users

  # Каталог товарів (головна сторінка)
  root to: 'products#index'
  resources :products, only: [:index, :show]  # Тільки index/show для каталогу/деталей
  get '/cart', to: 'cart#index', as: :cart
  post '/cart/add/:id', to: 'cart#add', as: :add_to_cart
  patch '/cart/update/:id', to: 'cart#update_quantity', as: :update_cart_quantity
  delete '/cart/clear', to: 'cart#clear', as: :clear_cart
  # Відгуки nested під продуктами (для /products/:id/reviews)
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:create, :edit, :update, :destroy]
  end

  # Кошик (додай для функції 3 з методички)
  resources :cart, only: [:index]  # GET /cart
  post '/cart/add/:id', to: 'cart#add'  # POST /cart/add/1

  # Додай пізніше: зворотний зв'язок, доставка, оплата
  # resources :contacts, only: [:new, :create]
  # resources :deliveries, only: [:new, :create]
  # resources :payments, only: [:new, :create]
  # resources :orders

  # Дефолт Rails (для Turbo/Stimulus, не чіпай)
  get '*path', to: 'application#fallback_index_html', constraints: ->(request) { request.xhr? }
end
