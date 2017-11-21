class Rental < ApplicationRecord
  before_save :geocode_endpoints
  has_one :user, through: :owner_id
  validates :owner_id, presence: true

  has_one :car

  validates :start_location, :end_location, presence: true

  geocoded_by :start_location,  latitude: :start_latitude, longitude: :start_longitude
  after_validation :geocode, if: ->(obj){ obj.start_location.present? }

  VALID_PRICE_REGEX = /\A\d+(\.\d\d)?\z/
  validates :price, presence: true, format: {with: VALID_PRICE_REGEX}

  validate :end_time_cannot_be_before_start

  def end_time_cannot_be_before_start
    if end_time < start_time
      errors.add(:end_time, 'can not be before the start time')
    end
  end

  def get_status_label
    Rental.status_int_to_label self.status
  end

  def self.status_int_to_label(i)
    case i
      when 0
        return 'Available'
      when 1
        return 'Upcoming'
      when 2
        return 'In Progress'
      when 3
        return 'Completed'
      when 4
        return 'Canceled'
      else
        return 'Error: Invalid Status'
    end
  end

  def self.status_label_to_int(label)
    case label
      when 'Available' 
        return 0
      when 'Upcoming' 
        return 1
      when 'In Progress' 
        return 2
      when 'Completed' 
        return 3
      when 'Canceled' 
        return 4
      else
        return -1
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
      return 'badge-success'
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
