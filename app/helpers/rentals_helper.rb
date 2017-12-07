module RentalsHelper
  def cache_key_for_rental(rental, owner, car)
    "rental/#{rental.id}/#{rental.updated_at}/#{owner.username}/#{car.make}-#{car.model}"
  end
end
