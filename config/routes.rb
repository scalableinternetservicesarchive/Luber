Rails.application.routes.draw do

  root 'static_pages#home'
  #  root 'home#index'

  get 'home', to: 'static_pages#home'

  get 'faq', to: 'static_pages#faq'

  get 'about', to: 'static_pages#about'

  get 'contact', to: 'static_pages#contact'

  get 'privacypolicy', to: 'static_pages#privacypolicy'

  post '/cars', to: 'cars#create'
  get 'tags/:tag', to: 'cars#tag_search', as: "tag"

  # Ugh, rails test error:
  # 
  # Error:
  # StaticPagesControllerTest#test_should_get_about:
  # NameError: undefined local variable or method `static_pages_about_url' for #<StaticPagesControllerTest:0x007fc9299989d8>
  #     test/controllers/static_pages_controller_test.rb:19:in `block in <class:StaticPagesControllerTest>'
  #
  # not sure why fixed when added these lines.
  # https://stackoverflow.com/questions/40509291/ruby-on-rails-error-undefined-local-variable-or-method
  # https://github.com/maxkim16/RailsError/blob/master/config/routes.rb
  get 'static_pages/home'
  get 'static_pages/faq'
  get 'static_pages/about'
  get 'static_pages/contact'
  get 'static_pages/privacypolicy'



  get 'users/new'

  resources :rental_posts
  resources :cars
  resources :users

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
