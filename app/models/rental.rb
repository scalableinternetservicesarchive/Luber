class Rental < ApplicationRecord
  has_one :user, through: :owner_id
  has_one :user, through: :renter_id
  has_one :car

  geocoded_by :start_location,  latitude: :start_latitude, longitude: :start_longitude
  after_validation :geocode, if: ->(obj){ obj.start_location.present? }

  VALID_PRICE_REGEX = /\A\d+(\.\d\d)?\z/
  validates :price, presence: true, format: {with: VALID_PRICE_REGEX}

  def get_status_label
    case self.status
    when 0
      return 'Available'
    when 1
      return 'Upcoming'
    when 2
      return 'In Progress'
    when 3
      return 'Completed'
    when 4
      return 'Cancelled'
    else
      return 'Error: Invalid Status'
    end
  end

  def get_status_class
    case self.status
    when 0
      return 'badge-primary'
    when 1
      return 'badge-info'
    when 2
      return 'badge-dark'
    when 3
      return 'badge-succes'
    when 4
      return 'badge-danger'
    else
      return 'Error: Invalid Status'
    end
  end
end
