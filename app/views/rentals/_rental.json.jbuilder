json.extract! rental, :id, :car_id, :user_id, :renter_id, :start_location, :end_location, :start_time, :end_time, :price, :created_at, :updated_at
json.url rental_url(rental, format: :json)
