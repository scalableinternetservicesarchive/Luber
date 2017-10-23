Rails.application.routes.draw do

  get 'static_pages/home'

  get 'static_pages/faq'

  get 'static_pages/about'

  get 'static_pages/contact'

  get 'static_pages/privacypolicy'

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
