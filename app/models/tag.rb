class Tag < ApplicationRecord
    before_save { self.name = name.downcase }
    has_many :taggings
    has_many :cars, through: :taggings

    validates :name, presence: true, length: { minimum: 3, maximum: 30 }
    validates_format_of :name, :with => /\A^[a-zA-Z0-9- ]*$\z/i
end
