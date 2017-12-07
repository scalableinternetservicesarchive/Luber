Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # jpp: run tests in a deterministic order; random test running is annoying.
  # http://guides.rubyonrails.org/configuring.html#configuring-active-support
  # from
  # http://edgeguides.rubyonrails.org/testing.html
  config.active_support.test_order = :sorted # vs :random

  # jpp: 
  # https://stackoverflow.com/questions/19600905/undefined-method-flash-for-actiondispatchrequest/23053260#23053260
  # (byebug) defined?(flash)
  # "method"
  # (byebug) flash()
  # *** NoMethodError Exception: undefined method `flash' for nil:NilClass
  #
  # nil
  # (byebug) flash('hi')
  # *** ArgumentError Exception: wrong number of arguments (given 1, expected 0)
  # config.middleware.use ActionDispatch::Flash



  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.middleware.use HtmlCompressor::Rack, options = {
    :enabled => true,
    :remove_spaces_inside_tags => true,
    :remove_multi_spaces => true,
    :remove_comments => true,
    :remove_intertag_spaces => false,
    :remove_quotes => false,
    :compress_css => false,
    :compress_javascript => false,
    :simple_doctype => false,
    :remove_script_attributes => false,
    :remove_style_attributes => false,
    :remove_link_attributes => false,
    :remove_form_attributes => false,
    :remove_input_attributes => false,
    :remove_javascript_protocol => false,
    :remove_http_protocol => false,
    :remove_https_protocol => false,
    :preserve_line_breaks => false,
    :simple_boolean_attributes => false,
    :compress_js_templates => false
  }

  # Make sure timezone is UTC in test
  config.tz = TZInfo::Timezone.get('UTC')
end
