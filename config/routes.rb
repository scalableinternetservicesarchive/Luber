Rails.application.routes.draw do


  get 'users/new'
  post '/cars', to: 'cars#create'

  resources :rental_posts
  resources :cars
  resources :users

  root 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
