class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  tz = TZInfo::Timezone.get('US/Pacific')
end
