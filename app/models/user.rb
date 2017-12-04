class User < ApplicationRecord
  before_save { self.first_name = first_name[0,1].upcase + first_name[1,first_name.length] if self.first_name.present? }
  before_save { self.last_name = last_name[0,1].upcase + last_name[1,last_name.length] if self.last_name.present? }
  before_save { self.city = city.titleize if self.city.present? }
  before_save { self.state = self.state = state[0,1].upcase + state[1,state.length] if self.state.present? }
  before_save { self.email = email.downcase }

  has_many :rentals
  has_many :logs
  has_many :cars, dependent: :destroy

  VALID_FIRST_NAME = /\A[a-z ]+\z/i
  VALID_LAST_NAME = /\A[a-z ]+\z/i
  VALID_CITY = /\A[a-z -]+\z/i
  VALID_STATE = /\A[a-z]+\z/i
  VALID_ABOUT = /\A[\w~!@#$%&*()+=\[\]\\|:'"\/?., -]+\z/i
  VALID_MEETUP = /\A[\w~!@#$%&*()+=\[\]\\|:'"\/?., -]+\z/i
  VALID_USERNAME = /\A[\w -]+\z/i
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :first_name, allow_blank: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_FIRST_NAME }
  validates :last_name, allow_blank: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_LAST_NAME }
  validates :city, allow_blank: true, length: { minimum: 2, maximum: 24 }, format: { with: VALID_CITY }
  validates :state, allow_blank: true, length: { minimum: 2, maximum: 24 }, format: { with: VALID_STATE }
  validates :about, allow_blank: true, length: { maximum: 1024 }, format: { with: VALID_ABOUT }
  validates :meetup, allow_blank: true, length: { maximum: 1024 }, format: { with: VALID_MEETUP }
  validates :username, presence: true, length: { minimum: 3, maximum: 24 }, format: { with: VALID_USERNAME }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { minimum: 5, maximum: 128 }, format: { with: VALID_EMAIL }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8, maximum: 64 },on: create
  validates :password, allow_blank: true, length: { minimum: 8, maximum: 64 }
  
  # If user is deleted, kill his cars too
  # https://stackoverflow.com/questions/29544693/cant-delete-object-due-to-foreign-key-constraint

  # returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def to_param
    username
  end

  def password_changed?(password)
    if self.password != password
      return true
    else
      return false
    end
  end
end
