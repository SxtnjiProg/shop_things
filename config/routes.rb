Rails.application.routes.draw do

  # =========================================================
  # 0. Технічні заглушки
  # =========================================================
  get '/.well-known/appspecific/com.chrome.devtools.json',
      to: proc { [204, {}, []] }

  # =========================================================
  # 1. Devise
  # =========================================================
  devise_for :users
  get '/auth', to: 'auth#index', as: :auth

  # =========================================================
  # 2. Головна + каталог
  # =========================================================
  root 'products#index'

  resources :categories

  resources :products do
    resources :reviews, only: [:create, :edit, :update, :destroy]
  end

  # =========================================================
  # 3. Профіль
  # =========================================================
  get  'profile',        to: 'users#show',        as: :profile
  patch 'profile/update', to: 'users#update_info', as: :update_user_info

  # =========================================================
  # 4. Кошик
  # =========================================================
  get    'cart',                         to: 'cart#index',           as: :cart_index
  post   'cart/add/:id',                 to: 'cart#add',             as: :add_to_cart
  patch  'cart/update/:product_id',      to: 'cart#update_quantity', as: :update_cart_quantity
  delete 'cart/clear',                   to: 'cart#clear',           as: :clear_cart

  # =========================================================
  # 5. Оформлення замовлення (CHECKOUT)
  # =========================================================
  get '/checkout', to: 'orders#new', as: :checkout

  # =========================================================
  # 6. Замовлення + оплата
  # =========================================================
  resources :orders, only: [:index, :show, :create, :update] do
    member do
      get   :payment          # /orders/:id/payment
      patch :process_payment  # /orders/:id/process_payment
    end
  end

end
