class Rental < ApplicationRecord
  before_save :geocode_endpoints
  after_save { 
    if self.renter_id_before_last_save == nil && self.renter_id.present?
      renter = User.find(self.renter_id)
      renter.update_attribute(:renter_rentals_count, renter.renter_rentals_count + 1)
    end
  }
  after_destroy { 
    if self.renter_id.present?
      renter = User.find(self.renter_id)
      renter.update_attribute(:renter_rentals_count, renter.renter_rentals_count - 1)
    end
  }

  belongs_to :user, counter_cache: true
  has_one :car

  attr_accessor :skip_in_seed

  
  VALID_LOCATION = /\A[a-z0-9.,' -]+\z/i
  VALID_PRICE = /\A\d+(\.\d\d)?\z/
  VALID_TERMS = /\A[\w~!@#$%&*()+=\[\]\\|:'"\/?., -]*\z/i

  validates :user_id, presence: true
  validates :car_id, presence: true
  validates :status, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 4, only_integer: true }
  validates :start_location, presence: true, length: { minimum: 3, maximum: 256 }, format: { with: VALID_LOCATION }
  validates :end_location, presence: true, length: { minimum: 3, maximum: 256 }, format: { with: VALID_LOCATION }
  validate :start_time_cannot_be_after_end_time, unless: :skip_in_seed
  validate :end_time_cannot_be_before_start_time, unless: :skip_in_seed
  validate :times_cannot_be_in_the_past, unless: :skip_in_seed
  validates :price, presence: true, length: { minimum: 1, maximum: 8 }, format: { with: VALID_PRICE }
  validates :terms, allow_blank: true, length: { maximum: 64 }, format: { with: VALID_TERMS }

  geocoded_by :start_location, latitude: :start_latitude, longitude: :start_longitude
  after_validation :geocode, if: ->(obj){ obj.start_location.present? }
  geocoded_by :end_location, latitude: :end_latitude, longitude: :end_longitude
  after_validation :geocode, if: ->(obj){ obj.end_location.present? }

  def start_time_cannot_be_after_end_time
    if self.end_time < self.start_time
      errors.add(:start_time, 'cannot be after the end time')
    end
  end

  def end_time_cannot_be_before_start_time
    if self.end_time < self.start_time
      errors.add(:end_time, 'cannot be before the start time')
    end
  end

  def times_cannot_be_in_the_past
    if self.start_time < DateTime.now && self.status > 1
      errors.add(:start_time, 'cannot be in the past')
    elsif self.end_time < DateTime.now && self.status > 2
      errors.add(:end_time, 'cannot be in the past')
    end
  end

  def get_status_label
    Rental.status_int_to_label self.status
  end

  MAX_STATUS = 4  # access via Rental::MAX_STATUS

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
