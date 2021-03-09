Rails.application.routes.draw do
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
    registrations: 'users/registrations'
  }

  namespace :admins do
    resources :menus, only:[:index, :show]
    resources :shops
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
    resources :orders, only:[:index, :show]
  end

  resources :users, only:[:show, :edit, :update] do
    resources :orders, only:[:index, :show]
  end

  resources :menus, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :orders, only:[:new, :create, :destroy]
    resources :cart_items, only:[:index, :create, :update, :destroy]
  end
  
  resources :categories, only:[:index,:new, :create, :edit, :update, :destroy]

end
