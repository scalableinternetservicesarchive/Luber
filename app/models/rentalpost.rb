class Rentalpost < ApplicationRecord
    belongs_to :user
    validates :content, length: {maximum: 1000}
end
