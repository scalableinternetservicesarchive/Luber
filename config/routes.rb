Rails.application.routes.draw do
  root 'static_pages#home'

  get 'home', to: 'static_pages#home'
  get 'faq', to: 'static_pages#faq'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'privacy', to: 'static_pages#privacy'

  resources :rental_posts
  resources :cars
  resources :users do
    member do
      get 'overview'
      get 'rentals'
      get 'cars'
      get 'history'
      get 'settings'
    end
  end

  get 'tags/:tag', to: 'cars#tag_search', as: "tag"

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
