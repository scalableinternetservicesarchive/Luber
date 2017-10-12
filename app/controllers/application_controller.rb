class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
      render html: "Welcome to Luber: A Car-sharing App"
  end
end
