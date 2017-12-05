module RentalsHelper
  def cache_key_for_rental(rental, owner, car)
    "rental/#{rental.id}/#{rental.updated_at}/#{owner.username}/#{car.make}-#{car.model}"
  end

  def cache_key_for_rentals_index(available_rentals, owners, cars)
    "rentals_index/#{available_rentals.first}/#{owners.first}/#{cars.first}"
  end
end
