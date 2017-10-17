json.extract! car, :id, :owner, :license_plate, :model, :color, :year, :condition, :created_at, :updated_at
json.url car_url(car, format: :json)
