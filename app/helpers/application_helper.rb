module ApplicationHelper
  def smart_time(dt)
    dt = Rails.application.config.tz.utc_to_local(dt)
    return dt.strftime("%-l:%M %p")
  end

  def smart_date(dt, prefix=false)
    dt = Rails.application.config.tz.utc_to_local(dt)
    case [dt.day, dt.month, dt.year]
    when [DateTime.yesterday.day, DateTime.yesterday.month, DateTime.yesterday.year]
      str = 'Yesterday'
    when [DateTime.current.day, DateTime.current.month, DateTime.current.year]
      str = 'Today'
    when [DateTime.tomorrow.day, DateTime.tomorrow.month, DateTime.tomorrow.year]
      str = 'Tomorrow'
    else
      if prefix then str = 'on ' else str = '' end
      if dt.month != 5 then dot = '.' else dot = '' end

      if dt.year != DateTime.current.year
        str << dt.strftime("%b#{dot} #{dt.day.ordinalize}, %Y")
      else
        str << dt.strftime("%A, %b#{dot} #{dt.day.ordinalize}")
      end
    end

    return str
  end

  def smart_datetime(dt, prefix=false)
    return "#{smart_date(dt, prefix)} at #{smart_time(dt)}"
  end

  def smart_datetime_range(dt_start, dt_end, prefix_start=false, prefix_end=false)
    dt = Rails.application.config.tz.utc_to_local(dt)
    if dt_start.day == dt_end.day
      str = "#{smart_date(dt_start)} from #{smart_time(dt_start)} until #{smart_time(dt_end)}"
    else
      str = "From #{smart_datetime(dt_start, prefix_start)} until #{smart_datetime(dt_end, prefix_end)}"
    end

    return str
  end

  def paginate(collection, params= {})
    will_paginate collection, params.merge(:renderer => LinkPaginationHelper::LinkRenderer)
  end

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end
end
