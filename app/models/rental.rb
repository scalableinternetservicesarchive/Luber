class Rental < ApplicationRecord
  before_save :geocode_endpoints
  has_one :user, through: :owner_id
  has_one :user, through: :renter_id
  has_one :car

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
      return ''
    end
  end

  private

  # Enable Geocoder to works with multiple locations
  def geocode_endpoints
    if start_location_changed?
      geocoded = Geocoder.search(start_location).first
      if geocoded
        self.start_latitude = geocoded.latitude
        self.start_longitude = geocoded.longitude
      end
    end
    # Repeat for destination
    if end_location_changed?
      geocoded = Geocoder.search(end_location).first
      if geocoded
        self.end_latitude = geocoded.latitude
        self.end_longitude = geocoded.longitude
      end
    end
  end
end
