Rails.application.routes.draw do

  root 'users#index'

  get 'users/new'

  resources :rental_posts
  resources :cars
  resources :users

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
