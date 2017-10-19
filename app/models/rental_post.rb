class RentalPost < ApplicationRecord
    has_one :user, through: :owner_id
    has_one :user, through: :renter_id
    has_one :car
end
