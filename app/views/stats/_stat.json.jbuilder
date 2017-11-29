json.extract! stat, :id, :total_deleted_users, :total_deleted_rentals, :total_deleted_cars, :created_at, :updated_at
json.url stat_url(stat, format: :json)
