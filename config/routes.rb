Rails.application.routes.draw do
  root "home#index"
  get "top", to: "home#top"
  get "about", to: "home#about"
  get "method", to: "home#method"
  get "shop", to: "home#shop"
  get "privacy", to: "home#privacy"
  get "term", to: "home#term"

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  devise_for :shops, controllers: {
    sessions:      'shops/sessions',
    passwords:     'shops/passwords',
    registrations: 'shops/registrations'
  }

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

  namespace :admins do
    resources :shops
    resources :menus, only:[:index, :show]
    resources :users, only:[:index, :show, :edit, :update]
    resources :orders, only:[:index]
  end
  resources :admins, only:[:index, :show, :edit, :update, :destroy]

  namespace :shops do
    resources :menus, only:[:index, :show]
    resources :orders, only:[:index, :show, :update, :destroy] do
      collection do
        get :today_index
      end
    end
  end
  resources :shops, only:[:index, :show, :edit, :update, :destroy] do
    resources :shop_images, only:[:index, :new, :create, :edit, :update, :destroy]
    resources :shop_tags, only:[:new, :create, :edit, :update, :destroy]
    resources :holidays, only:[:index, :new, :create, :destroy]
    resources :business_hours, only:[:index, :new, :create, :edit, :update, :destroy]
    resources :sales, only:[:index, :show] do
      collection do
        get :month
        get :year
      end
    end
  end

  namespace :users do
    resources :shops, only:[:index, :show] do
      member do
        get :infomation
      end
      collection do
        get :search
      end
    end
  end

  resources :users, only:[:show, :edit, :update] do
    resources :orders, only:[:index, :show]
    resources :cart_items, only:[:index]
  end

  resources :menus, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get :search
    end
    resources :menu_images, only:[:index, :new, :create, :edit, :update, :destroy]
    resources :menu_tags, only:[:new, :create, :destroy]
    resources :orders, only:[:new, :create, :destroy]
    resources :cart_items, only:[:create, :update]
  end

  namespace :cart_items do
    resources :orders, only:[:new, :create]
  end

  get "orders/fix", to: "orders#fix"
  resources :cart_items, only:[:destroy]
  resources :categories, only:[:index,:new, :create, :edit, :update, :destroy]
  resources :shop_contacts, only:[:index, :show, :new, :create] do
    collection do
      get :fix
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

end
