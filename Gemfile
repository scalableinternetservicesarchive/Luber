source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# DESCRIBE ME
gem 'rails-controller-testing'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Use Boostrap to make better CSS
gem 'bootstrap', '~> 4.0.0.beta2.1'
# Use Autoprefixer to add vendor-prefixes to CSS at compile time
gem 'autoprefixer-rails', '~> 7.1.6'
# Use Font Awesome or neat icons
gem 'font-awesome-sass', '~> 4.7.0'
# Pagination (jpp) https://www.railstutorial.org/book/updating_and_deleting_users#sec-pagination
gem 'will_paginate',           '3.1.5'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# DESCRIBE ME
gem 'foundation-rails'
# DESCRIBE ME
gem 'geocoder'
# DESCRIBE ME
gem 'groupdate'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Strip whitespace for test validations
  gem 'htmlcompressor', '~> 0.3.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # DESCRIBE ME
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # DESCRIBE ME
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Favicon generator
  gem 'rails_real_favicon'
end

group :production do
  # DESCRIBE ME
  gem 'pg'
end
