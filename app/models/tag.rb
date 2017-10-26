class Tag < ApplicationRecord
    has_many :taggings
    has_many :cars, through: :taggings
end
