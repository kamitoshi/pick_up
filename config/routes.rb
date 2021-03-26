Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  root "home#index"

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
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

  namespace :admins do
    resources :shops
    resources :menus, only:[:index, :show]
    resources :users, only:[:index, :show, :edit, :update]
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
  resources :shops, only:[:show, :edit, :update, :destroy] do
    resources :shop_images, only:[:index, :new, :create, :edit, :update, :destroy]
    resources :shop_tags, only:[:new, :create, :edit, :update, :destroy]
    resources :business_hours, only:[:index, :new, :create, :edit, :update, :destroy]
  end

  namespace :users do
    resources :shops, only:[:index, :show]
  end

  resources :users, only:[:show, :edit, :update] do
    resources :orders, only:[:index, :show]
    resources :cart_items, only:[:index]
  end

  resources :menus, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :menu_images, only:[:index, :new, :create, :edit, :update, :destroy]
    resources :menu_tags, only:[:new, :create, :destroy]
    resources :orders, only:[:new, :create, :destroy]
    resources :cart_items, only:[:create, :update]
  end

  namespace :cart_items do
    resources :orders, only:[:new, :create]
  end
  resources :cart_items, only:[:destroy]
  resources :categories, only:[:index,:new, :create, :edit, :update, :destroy]

end
