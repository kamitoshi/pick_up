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
  devise_scope :shop do
    get 'shops/confirm_email', to: 'shops/registrations#confirm_email'
  end
  resources :admins, only:[:index, :show, :edit, :update, :destroy]
  resources :shops, only:[:index, :show, :edit, :update, :destroy]
  resources :categories, only:[:index,:new, :create, :edit, :update, :destroy]

end
