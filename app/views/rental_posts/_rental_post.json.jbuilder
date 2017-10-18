json.extract! rental_post, :id, :car_id, :owner_id, :renter_id, :start_location, :end_location, :start_time, :end_time, :price, :created_at, :updated_at
json.url rental_post_url(rental_post, format: :json)
