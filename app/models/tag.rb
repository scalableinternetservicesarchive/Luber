class Tag < ApplicationRecord
    before_save { self.name = name.downcase }

    has_many :taggings
    has_many :cars, through: :taggings

    VALID_TAG = /\A^[a-z0-9-]+$\z/i

    validates :name, presence: true, length: { minimum: 3, maximum: 30 }, format: { with: VALID_TAG }
end
