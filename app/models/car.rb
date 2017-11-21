class Car < ApplicationRecord
  before_save { self.license_plate = license_plate.upcase }
  before_save { self.make = make[0,1].upcase + make[1,make.length] }
  before_save { self.model = model[0,1].upcase + model[1,model.length] }
  before_save { self.color = color.capitalize }
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings

  # http://guides.rubyonrails.org/active_record_validations.html#validates-each
  validates_each :license_plate do |record, attr, value|
    record.errors.add(attr, 'must have length 2 to 7') unless (value.length >= 2) && (value.length <= 7)
    record.errors.add(attr, 'must be only letters, numbers, or spaces') unless value.match /\A[a-z0-9 ]+\z/i
    record.errors.add(attr, 'must have at least two non-space characters') unless value.match /\A.*[a-z0-9].*[a-z0-9].*\z/i
  end

  validates :year, presence: true, numericality: { greater_than: 1900, less_than: DateTime.now.year + 3, only_integer: true }
  validates :make, presence: true, length: { minimum: 3, maximum: 30 }
  validates :model, presence: true, length: { minimum: 3, maximum: 30 }
  validates :color, presence: true, length: { minimum: 3, maximum: 30 }
  validates_format_of :color, :with => /\A[-a-z]+\Z/i

  def all_tags=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    tags.map(&:name).join(', ')
  end

  def self.tagged_with(name)
    name = name.downcase
    Tag.find_by_name!(name).cars
  end
end
