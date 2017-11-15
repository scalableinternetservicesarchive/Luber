class Car < ApplicationRecord
    belongs_to :user
    has_many :taggings
    has_many :tags, through: :taggings

    PLATE_REGEX = /\A\d{1}[a-z]{3}\d{3}\z/i
    validates :plate_number, presence: true, length: {is: 7}, format: {with: PLATE_REGEX}
    validates :year, presence: true, numericality: {greater_than: 1900}

    def all_tags=(names)
      self.tags = names.split(",").map do |name|
          Tag.where(name: name.strip).first_or_create!
      end
    end

    def all_tags
      self.tags.map(&:name).join(", ")
    end

    def self.tagged_with(name)
      Tag.find_by_name!(name).cars
    end
end
