json.extract! rental_post, :id, :car, :owner, :renter, :start_loc, :end_loc, :start_time, :end_time, :cost, :created_at, :updated_at
json.url rental_post_url(rental_post, format: :json)
