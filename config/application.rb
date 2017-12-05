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

    # Use javascript (.js) instead of coffeescript (.coffee)
    # https://stackoverflow.com/questions/24232570/how-to-configure-rails-3-2-4-to-generate-js-instead-of-js-coffee-by-default
    config.generators do |g|
      g.javascript_engine :js
    end

    # Override default invalid form field behavior to avoid breaking CSS and add 'is-invalid' class
    # https://stackoverflow.com/questions/5267998/rails-3-field-with-errors-wrapper-changes-the-page-appearance-how-to-avoid-t
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      class_attr_index = html_tag.index 'class="'

      if class_attr_index
        html_tag.insert class_attr_index+7, 'is-invalid '
      else
        html_tag.insert html_tag.index('>'), ' class="is-invalid"'
      end
    }
  end
end
