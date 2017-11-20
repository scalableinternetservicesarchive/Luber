class Car < ApplicationRecord
    before_save {self.license_plate = license_plate.upcase}
    belongs_to :user
    has_many :taggings
    has_many :tags, through: :taggings

    # http://guides.rubyonrails.org/active_record_validations.html#validates-each
    validates_each :license_plate do |record, attr, value|
        # puts "Checking plate number #{value}"
        record.errors.add(attr, 'must have length 2 to 7') if not (2 <= value.length and value.length <= 7)
        record.errors.add(attr, 'must be only letters, numbers, or spaces') if not value.match? /\A[a-z0-9 ]+\z/i
        record.errors.add(attr, 'must have at least two non-space characters') if not value.match? /\A.*[a-z0-9].*[a-z0-9].*\z/i
      end
    
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
      name = name.downcase
      Tag.find_by_name!(name).cars
    end
end
