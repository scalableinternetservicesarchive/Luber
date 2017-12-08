class User < ApplicationRecord
  before_save { self.first_name = first_name[0,1].upcase + first_name[1,first_name.length] if self.first_name.present? }
  before_save { self.last_name = last_name[0,1].upcase + last_name[1,last_name.length] if self.last_name.present? }
  before_save { self.city = city.titleize if self.city.present? }
  before_save { self.state = self.state = state[0,1].upcase + state[1,state.length] if self.state.present? }
  before_save { self.email = email.downcase }
  before_destroy :handle_associated_owner_rentals
  before_destroy :handle_associated_renter_rentals

  has_many :rentals, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_many :logs, dependent: :destroy

  VALID_FIRST_NAME = /\A[a-z ]+\z/i
  VALID_LAST_NAME = /\A[a-z ]+\z/i
  VALID_CITY = /\A[a-z -]+\z/i
  VALID_STATE = /\A[a-z]+\z/i
  VALID_ABOUT = /\A[\w\r\n`~!@#\$%\^&\*\(\)\-\+=\[\]\{\}\\|:'",<\.>\/\? ]+\z/
  VALID_MEETUP = /\A[\w\r\n`~!@#\$%\^&\*\(\)\-\+=\[\]\{\}\\|:'",<\.>\/\? ]+\z/
  VALID_USERNAME = /\A[\w -]+\z/i
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_PASSWORD = /\A[\w`~!@#\$%\^&\*\(\)\-\+=\[\]\{\}\\|;:'",<\.>\/\?]+\z/

  validates :first_name, allow_blank: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_FIRST_NAME }
  validates :last_name, allow_blank: true, length: { minimum: 2, maximum: 16 }, format: { with: VALID_LAST_NAME }
  validates :city, allow_blank: true, length: { minimum: 2, maximum: 24 }, format: { with: VALID_CITY }
  validates :state, allow_blank: true, length: { minimum: 2, maximum: 24 }, format: { with: VALID_STATE }
  validates :about, allow_blank: true, length: { maximum: 1024 }, format: { with: VALID_ABOUT }
  validates :meetup, allow_blank: true, length: { maximum: 1024 }, format: { with: VALID_MEETUP }
  validates :username, presence: true, length: { minimum: 3, maximum: 24 }, format: { with: VALID_USERNAME }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { minimum: 5, maximum: 128 }, format: { with: VALID_EMAIL }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }, format: { with: VALID_PASSWORD }, if: :create_should_validate?
  validates :password, length: { minimum: 8, maximum: 32 }, format: { with: VALID_PASSWORD }, if: :update_should_validate?

  # If user is deleted, kill his cars too
  # https://stackoverflow.com/questions/29544693/cant-delete-object-due-to-foreign-key-constraint

  def create_should_validate?
    new_record?
  end

  def update_should_validate?
    !self.password.nil?
  end

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

  def handle_associated_owner_rentals
    if self.rentals_count == 0
      return true
    else
      in_progress_rentals = Rental.where(['user_id = ? AND status = ?', self.id, 2]).count
      if in_progress_rentals == 0
        return true
      else
        err_str = "You are the owner of #{in_progress_rentals} "
        in_progress_rentals == 1 ? err_str += 'rental' : err_str += 'rentals'
        err_str += ' currently in progress. You must wait for '
        in_progress_rentals == 1 ? err_str += 'it' : err_str += 'them'
        err_str += ' to complete before you can delete your account'
        errors.add :base, err_str
        throw(:abort)
      end
    end
  end

  def handle_associated_renter_rentals
    if self.renter_rentals_count != 0
      Rental.where(renter_id: self.id).each do |rental|
        rental.update_column(:renter_id, nil)
        rental.update_column(:renter_deleted, true)
      end
    end
    return true
  end
end
