Rails.application.routes.draw do

  resources :rental_posts
  resources :cars
  get 'users/new'


  resources :users
  root 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
