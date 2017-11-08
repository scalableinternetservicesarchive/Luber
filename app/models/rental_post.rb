class RentalPost < ApplicationRecord
    has_one :user, through: :owner_id
    has_one :user, through: :renter_id
    has_one :car
    geocoded_by :start_location,  latitude: :start_latitude, longitude: :start_longitude
    after_validation :geocode, if: ->(obj){ obj.start_location.present? }

end
