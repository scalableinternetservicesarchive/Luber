class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  include SessionsHelper

  def validate_page(page, total, per)
    page = page.to_s
    last = (total / per.to_f).ceil
    if page.match?(/\A\d+\z/)
      page = page.to_i
      if page < 1
        page = 1
      elsif page > last
        page = last
      end
    else
      page = 1
    end

    return page
  end
end
