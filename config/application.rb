require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LuberApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Attempting to prevent scaffold.scss from being generated
    # https://stackoverflow.com/questions/5966776/rails-scaffold-without-the-css-file
    config.generators do |g|
      g.scaffold_stylesheet false
    end
  end
end
