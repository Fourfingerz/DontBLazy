Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  post   'users/verify'  => 'users#verify'
  delete 'logout'  => 'sessions#destroy'
  post 'process_sms' => 'microposts#receive_sms'
  
  resources :users do
    collection do
      patch 'phone_entry', :action => :add_phone
    end
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :show, :edit, :update, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :recipients,          only: [:new, :create, :edit, :update, :destroy]
end
