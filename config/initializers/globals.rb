Rails.application.configure do
  # Hard-coded timezone (for client-side rendering ONLY, all DateTime's in the db should be left UTC)
  # TODO: add user.timezone field and allow users to select their own timezone, with PST as the default
  config.tz = TZInfo::Timezone.get('US/Pacific')
end