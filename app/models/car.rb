class Car < ApplicationRecord
  before_save { self.make = make[0,1].upcase + make[1,make.length] }
  before_save { self.model = model[0,1].upcase + model[1,model.length] }
  before_save { self.color = color.titleize }
  before_save { self.license_plate = license_plate.upcase }

  belongs_to :user, counter_cache: true
  has_many :taggings
  has_many :tags, through: :taggings

  VALID_MAKE = /\A[a-z0-9 -]+\z/i
  VALID_MODEL = /\A[a-z0-9 -]+\z/i
  VALID_COLOR = /\A[a-z ]+\z/i

  validates :user_id, presence: true
  validates :make, presence: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_MAKE }
  validates :model, presence: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_MODEL }
  validates :color, presence: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_COLOR }
  validates :year, numericality: { greater_than: 1899, less_than: DateTime.now.year + 3, only_integer: true }
  # http://guides.rubyonrails.org/active_record_validations.html#validates-each
  validates_each :license_plate do |record, attr, value|
    record.errors.add(attr, 'must have length 2 to 7') unless (value.length >= 2) && (value.length <= 7)
    record.errors.add(attr, 'must be only letters, numbers, or spaces') unless value.match /\A[a-z0-9 ]+\z/i
    record.errors.add(attr, 'must have at least two non-space characters') unless value.match /\A.*[a-z0-9].*[a-z0-9].*\z/i
  end

  def all_tags=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip.gsub(/[\s-]+/, '-')).first_or_create!
    end
  end

  def all_tags
    tags.map(&:name).join(', ')
  end

  def self.tagged_with(name)
    name = name.downcase
    Tag.find_by_name!(name).cars
  end

  before_destroy :remove_taggings

  def remove_taggings
    Tagging.where(car_id: id).destroy_all
  end
end
