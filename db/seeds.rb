# jpp
# http://www.xyzpub.com/en/ruby-on-rails/3.2/seed_rb.html
# https://davidmles.com/seeding-database-rails/
# https://stackoverflow.com/questions/27931101/password-cant-be-blank-error-when-seeding-database
#
# Bryce says: use db:reset at rails console instead of destroying things manually in this file.
# https://piazza.com/class/j789lo09yai5qx?cid=56

###############################################
# SEED DATA FOR ALL ENVIRONMENTS
###############################################

###############################################
# LOAD ENVIRONMENT-SPECIFIC SEED DATA
###############################################

load(Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb"))