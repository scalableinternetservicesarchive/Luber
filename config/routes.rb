Rails.application.routes.draw do

  root 'static_pages#home'
  #  root 'home#index'

  get 'home', to: 'static_pages#home'

  get 'faq', to: 'static_pages#faq'

  get 'about', to: 'static_pages#about'

  get 'contact', to: 'static_pages#contact'

  get 'privacypolicy', to: 'static_pages#privacypolicy'



  get 'users/new'

  post '/cars', to: 'cars#create'

  resources :rental_posts
  resources :cars
  resources :users

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
