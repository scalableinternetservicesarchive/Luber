class Tag < ApplicationRecord
    before_save {self.name = name.downcase}
    has_many :taggings
    has_many :cars, through: :taggings

    VALID_TAG_REGEX = /\A^[a-zA-Z0-9_ -]*$\z/i
    validates :name, presence: true, length: {maximum: 255},
            format: {with: VALID_TAG_REGEX, message: "Tags can only contain letters, digits, -, _ or space."}

end
