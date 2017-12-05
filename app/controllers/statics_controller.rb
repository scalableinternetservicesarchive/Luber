class StaticsController < ApplicationController
  def home
    # So much for this being static ¯\_(ツ)_/¯
    @total_users_count = User.all.count
    @total_cars_count = Car.all.count
    @total_rentals_count = Rental.all.count
  end

  def faq
  end

  def about
  end

  def contact
  end

  def privacy
  end
end
