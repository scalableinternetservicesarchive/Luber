Rails.application.routes.draw do

  root 'home#index'

  get 'users/new'

  post '/cars', to: 'cars#create'

  resources :rental_posts
  resources :cars
  resources :users

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
