Rails.application.routes.draw do
  resources :stats
  root 'statics#home'

  get 'home', to: 'statics#home'
  get 'faq', to: 'statics#faq'
  get 'about', to: 'statics#about'
  get 'contact', to: 'statics#contact'
  get 'privacy', to: 'statics#privacy'

  resources :users, param: :username, except: [:index, :new, :create] do
    member do
      get 'overview'
      get 'rentals'
      get 'cars'
      get 'history'
      get 'settings'
      patch 'promote'
    end
  end
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  delete 'signout', to: 'sessions#destroy'
  
  resources :rentals do
    member do
      patch 'rent'
      patch 'cancel'
      patch 'remove'
    end
  end

  resources :cars, except: [:index, :show]
  get 'tags/:tag', to: 'cars#tag_search', as: 'tag'

end