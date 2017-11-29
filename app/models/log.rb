class Log < ApplicationRecord
  belongs_to :user

  def get_action_icon
    case self.action
    when 0
      return 'plus'
    when 1
      return 'pencil'
    when 2
      return 'minus'
    when 3
      return 'check'
    when 4
      return 'times'
    else
      return ''
    end
  end

  def get_action_class
    case self.action
    when 0
      return 'log-purple'
    when 1, 3
      return 'log-green'
    when 2, 4
      return 'log-red'
    else
      return ''
    end
  end
end