class Rental < ApplicationRecord
  has_one :user, through: :owner_id
  has_one :user, through: :renter_id
  has_one :car

  def get_status_label
    case self.status
    when 0
      return 'Available'
    when 1
      return 'Upcoming'
    when 2
      return 'In Progress'
    when 3
      return 'Completed'
    when 4
      return 'Cancelled'
    else
      return 'Error: Invalid Status'
    end
  end

  def get_status_class
    case self.status
    when 0
      return 'badge-primary'
    when 1
      return 'badge-info'
    when 2
      return 'badge-dark'
    when 3
      return 'badge-succes'
    when 4
      return 'badge-danger'
    else
      retun 'Error: Invalid Status'
    end
  end
end
