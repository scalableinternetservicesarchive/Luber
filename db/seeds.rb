###############################################
# SEEDING

# jpp
# http://www.xyzpub.com/en/ruby-on-rails/3.2/seed_rb.html
# https://davidmles.com/seeding-database-rails/
# https://stackoverflow.com/questions/27931101/password-cant-be-blank-error-when-seeding-database
#
# Bryce says: use db:reset at rails console instead of destroying things manually in this file.
# https://piazza.com/class/j789lo09yai5qx?cid=56

###############################################


###############################################
# GLOBAL STATE
###############################################

# Car resources
$all_car_makes = ['Toyota','Ford','Nissan','BMW','Mazda','Mercedes','Volkswagen','Audi','Kia','Hyundai','Subaru']
$all_car_models = ['Civic','Accord','Camry','F-150','Wrangler','Highlander','Grand Cherokee','Tacoma','Outback','Forester',
  'Equinox','Explorer','Mustang','Camaro','Tacoma','Odyssey','Silverado','Escape','Corolla','Tahoe','Fusion','Charger']
$all_car_colors = ['Red','Orange','Yellow','Green','Blue','Purple','Black','White','Gray','Silver']

# Rental resources
$all_locations = {
  "Los Angeles, CA"       => [34.0194, -118.411],
  "San Diego, CA"         => [32.8153, -117.135],
  "San Jose, CA"          => [37.2969, -121.819],
  "San Francisco, CA"     => [37.7599, -122.437],
  "Fresno, CA"            => [36.7827, -119.794],
  "Sacramento, CA"        => [38.5666, -121.469],
  "Long Beach, CA"        => [33.8091, -118.155],
  "Oakland, CA"           => [37.7699, -122.226],
  "Bakersfield, CA"       => [35.3212, -119.018],
  "Anaheim, CA"           => [33.8362, -117.890],
  "Santa Ana, CA"         => [33.7365, -117.883],
  "Riverside, CA"         => [33.9381, -117.393],
  "Stockton, CA"          => [37.9763, -121.313],
  "Chula Vista, CA"       => [32.6277, -117.015],
  "Irvine, CA"            => [33.6784, -117.771],
  "Fremont, CA"           => [37.4944, -121.941],
  "San Bernardino, CA"    => [34.1393, -117.295],
  "Modesto, CA"           => [37.6609, -120.989],
  "Oxnard, CA"            => [34.2023, -119.205],
  "Fontana, CA"           => [34.1088, -117.463],
  "Moreno Valley, CA"     => [33.9233, -117.206],
  "Huntington Beach, CA"  => [33.6906, -118.009],
  "Glendale, CA"          => [34.1814, -118.246],
  "Santa Clarita, CA"     => [34.4049, -118.505],
  "Garden Grove, CA"      => [33.7788, -117.960],
  "Oceanside, CA"         => [33.2246, -117.306],
  "Rancho Cucamonga, CA"  => [34.1233, -117.564],
  "Santa Rosa, CA"        => [38.4468, -122.706],
  "Ontario, CA"           => [34.0395, -117.609],
  "Elk Grove, CA"         => [38.4144, -121.385],
  "Corona, CA"            => [33.8624, -117.564],
  "Lancaster, CA"         => [34.6936, -118.175],
  "Palmdale, CA"          => [34.5913, -118.109],
  "Salinas, CA"           => [36.6902, -121.634],
  "Hayward, CA"           => [37.6281, -122.106],
  "Pomona, CA"            => [34.0586, -117.761],
  "Escondido, CA"         => [33.1336, -117.073],
  "Sunnyvale, CA"         => [37.3858, -122.026],
  "Torrance, CA"          => [33.8350, -118.341],
  "Pasadena, CA"          => [34.1606, -118.140],
  "Orange, CA"            => [33.8048, -117.825],
  "Fullerton, CA"         => [33.8857, -117.928],
  "Thousand Oaks, CA"     => [34.1933, -118.874],
  "Visalia, CA"           => [36.3272, -119.323],
  "Roseville, CA"         => [38.7657, -121.303],
  "Concord, CA"           => [37.9722, -122.002],
  "Simi Valley, CA"       => [34.2669, -118.748],
  "East Los Angeles, CA"  => [34.0315, -118.169],
  "Santa Clara, CA"       => [37.3646, -121.968],
  "Victorville, CA"       => [34.5277, -117.354],
  "Vallejo, CA"           => [38.1079, -122.264],
  "Berkeley, CA"          => [37.8667, -122.299],
  "El Monte, CA"          => [34.0746, -118.029],
  "Downey, CA"            => [33.9382, -118.131],
  "Costa Mesa, CA"        => [33.6659, -117.912],
  "Carlsbad, CA"          => [33.1239, -117.283],
  "Inglewood, CA"         => [33.9561, -118.344],
  "Fairfield, CA"         => [38.2568, -122.040],
  "Ventura, CA"           => [34.2681, -119.255],
  "Temecula, CA"          => [33.5019, -117.125],
  "Antioch, CA"           => [37.9775, -121.798],
  "Richmond, CA"          => [37.9530, -122.359],
  "West Covina, CA"       => [34.0559, -117.910],
  "Murrieta, CA"          => [33.5719, -117.191],
  "Norwalk, CA"           => [33.9069, -118.083],
  "Daly City, CA"         => [37.7009, -122.465],
  "Burbank, CA"           => [34.1890, -118.325],
  "Santa Maria, CA"       => [34.9332, -120.444],
  "El Cajon, CA"          => [32.8017, -116.960],
  "San Mateo, CA"         => [37.5603, -122.311],
  "Rialto, CA"            => [34.1118, -117.388],
  "Clovis, CA"            => [36.8289, -119.687]
}
$all_terms = [
 "Take time to know yourself.",
 "A narrow focus brings big results.",
 "Show up fully.",
 "Dont make assumptions.",
 "Be patient and persistent.",
 "In order to get, you have to give.",
 "Luck comes from hard work.",
 "Be your best at all times.",
 "Dont try to impress everyone.",
 "Dont be afraid of being afraid.",
 "Listen to learn.",
 "Lifes good, but its not fair.",
 "No task is beneath you.",
 "You cant always get what you want.",
 "Dont make decisions when you are angry or ecstatic.",
 "Dont worry what other people think.",
 "Use adversity as an opportunity.",
 "Do what is right, not what is easy.",
 "Dreams remain dreams until you take action.",
 "Treat others the way you want to be treated.",
 "When you quit, you fail.",
 "Trust your instincts.",
 "Learn something new every day.",
 "Make what is valuable important.",
 "Believe in yourself."]

# Tag resources
$all_tags = ['no-smoking', 'sunroof', '5-seater', 'sporty', 'child-car-seat', 'SUV', 'off-road', 'moon-roof', 'smoking', 
  'tinted', 'fold-down-seats', 'curtains','cup-holders','arm-rests','bed','fridge','leather','stereo','backseat-tv','satellite-dish']


###############################################
# LOAD SPECIFIC ENVIRONMENT
###############################################

case Rails.env
  when 'test', 'development'
    puts 'IN LOCAL MODE (' + Rails.env + ')'
    $how_many = {user: 10, cars_per_user: 2, rentals_per_car: 5}
    $col_name_delim = "`" # sqlite3
    $val_delim = '"'  # sqlite3
    $direct_sql_inject = false
    load(Rails.root.join( 'db', 'seeds', 'local.rb'))
  when 'production'
    puts 'IN REMOTE MODE (production)'
    $how_many = {user: 1000, cars_per_user: 2, rentals_per_car: 5}
    $col_name_delim = "" # postgres
    $val_delim = "'"  # postgres
    $direct_sql_inject = true
    load(Rails.root.join( 'db', 'seeds', 'remote.rb'))
end
