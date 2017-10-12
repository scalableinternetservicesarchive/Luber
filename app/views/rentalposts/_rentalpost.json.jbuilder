json.extract! rentalpost, :id, :content, :user_id, :created_at, :updated_at
json.url rentalpost_url(rentalpost, format: :json)
