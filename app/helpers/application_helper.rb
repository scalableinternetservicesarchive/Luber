module ApplicationHelper
  def utc_to_local(dt)
    return Rails.application.config.tz.utc_to_local(dt)
  end

  def local_to_utc(dt)
    return Rails.application.config.tz.local_to_utc(dt)
  end

  def smart_time(dt, converted=false)
    dt = utc_to_local(dt) if !converted
    return dt.strftime("%-l:%M %p")
  end

  def smart_date(dt, prefix=false, converted=false)
    dt = utc_to_local(dt) if !converted
    yesterday = utc_to_local(DateTime.yesterday.to_datetime)
    today = utc_to_local(DateTime.current)
    tomorrow = utc_to_local(DateTime.tomorrow.to_datetime)
    case [dt.day, dt.month, dt.year]
    when [yesterday.day, yesterday.month, yesterday.year]
      str = 'Yesterday'
    when [today.day, today.month, today.year]
      str = 'Today'
    when [tomorrow.day, tomorrow.month, tomorrow.year]
      str = 'Tomorrow'
    else
      if prefix then str = 'on ' else str = '' end
      if dt.month != 5 then dot = '.' else dot = '' end

      if dt.year != today.year
        str << dt.strftime("%b#{dot} #{dt.day.ordinalize}, %Y")
      else
        str << dt.strftime("%A, %b#{dot} #{dt.day.ordinalize}")
      end
    end

    return str
  end

  def smart_datetime(dt, prefix=false, converted=false)
    if !converted
      dt = utc_to_local(dt)
      converted = true
    end
    return "#{smart_date(dt, prefix, converted)} at #{smart_time(dt, converted)}"
  end

  def smart_datetime_range(dt_start, dt_end, prefix_start=false, prefix_end=false)
    dt_start = utc_to_local(dt_start)
    dt_end = utc_to_local(dt_end)
    if dt_start.day == dt_end.day && dt_start.month == dt_end.month && dt_start.year == dt_end.year
      str = "#{smart_date(dt_start, prefix_start, true)} from #{smart_time(dt_start, true)} until #{smart_time(dt_end, true)}"
    else
      str = "From #{smart_datetime(dt_start, prefix_start, true)} until #{smart_datetime(dt_end, prefix_end, true)}"
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
