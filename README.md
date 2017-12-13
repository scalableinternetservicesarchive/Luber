# Luber: :oncoming_automobile: A ride-sharing App :oncoming_taxi: [![Build Status](https://travis-ci.org/scalableinternetservices/Luber.svg?branch=master)](https://travis-ci.org/scalableinternetservices/Luber)

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [Deploying to Heroku](#deploying-to-heroku)
- [Deploying to AWS Elastic Beanstalk](#deploying-to-aws-elastic-beanstalk)
- [Load testing with Tsung](#load-testing-with-tsung)
- [Tips](#tips)
- [References](#references)
- [Team Members](#team-members)

## About

[Project Report (PDF)](doc/cs291-project-luber-aws-tsung.pdf)

[Project Presentation (PDF)](doc/Luber-Presentation.pdf)

Sharing economy is efficient, environment-friendly and accessible to all. Uber and Airbnb have swept out the traditional rental business in every aspect. It's much faster and more convenient to ask for a ride by Uber or Lyft, however, sometimes a ride is not sufficient for all travelling demand, in case of family trip, long journey or private event. Therefore, We'd like to work on a Uber-like car-sharing app for CS291A project.

The app is basically a booking system, in which the car owners can post the availability of their car in terms of time, location, model, mileage, photo and price. On the flipping side, the car users can search in the same manner and app will find the best match for both side. At the reserved time and location, the user will pick up the car from the owner and return it, perhaps at another location. All transactions are made online and a rating and review system in app is for users and owners to build up their reputation across board.

This app will have a web version at first, and then derives to a mobile version afterwards.

[Piazza Post](https://piazza.com/class/j789lo09yai5qx?cid=7)


## Getting Started

1. Make sure Ruby, Rails, and any other tools (such as RVM) are installed and ready to go (click [here](http://installrails.com/steps/choose_os) for geenral installation instructions and [here](https://rvm.io/) for RVM)

2. Clone the repo
```sh
git clone git@github.com:scalableinternetservices/Luber.git
cd Luber
```

3. Setup the project and test that the server starts succesfully
```sh
# Install gem dependencies
bundle install --without production

# If you're on linux you may need to do the following to increase your number of watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# Migrate and reset the databse
rails db:migrate
rails db:reset
rails s

# By default the server should start on http://localhost:3000/
# If you run into issues with the db, try deleting /db/development.sqlite3, test.sqlite3, schema.rb, and running the commands again
```

## Contributing

In order to contribute, complete the `Setup` section, then follow the general flow outlined below

1. Make sure the master branch builds and you can navigate around the site. Familiarize yourself with the codebase

2. Once you have a specific feature/issue you want to work on, create a new branch for that feature

3. Use test-driven development where applicable to create your new feature/resolve the given issue, and once thoroughly tested, submit a pull request on [GitHub](https://github.com/scalableinternetservices/Luber/pulls)

4. Once your code is peer-reviewd and any Travis CI issues are resolved, merge the branch into master
```sh
# Make sure master is up-to-date
git pull origin master

# Make your new branch
git checkout -b my-feature-branch

# Do work son
git add -D

# Make sure tests pass and perform any needed fixes/updates
rails t

# Commit and push work
git commit -m "made this cool thing"
git push origin my-feature-branch

# Merge (or rebase if you're into that) with master
git merge master

# Resolve conflicts and re-commit changes
git add -D
git commit -m "merged with master"
git push origin my-feature-branch

# Open a pull request on the GitHub page and assign someone to review it
```

## Deploying to Heroku

1. Make an account on [Heroku](https://signup.heroku.com/)

2. From your local Luber directory, verify that the application is seeding/testing/running correctly
```sh
rails db:migrate
rails db:reset
rails t
rails s
```

3. [Install Heroku](https://devcenter.heroku.com/articles/heroku-cli), login, and add a SSH key (installing will differ depending on your OS)
```sh
# Install then verify a version appears
heroku version

# Login and either add a SSH key or make a new one (may need to specify path when adding)
heroku login
ssh-keygen -t rsa -C "Heroku ssh key for our Luber"
heroku keys:add
```

4. From your local Luber directory, create a heroku app and deploy it to heroku
```sh
heroku create
git push heroku master
# If you are pushing a branch other than master to heroku master, use:
# git push heroku other-branch:master
```

5. Migrate/seed the database and precompile assets
```sh
# NOTE: To run commands (or specifically run bash and access the terminal) on your remote heroku machine use:
heroku run # insert command here
heroku run bash

# Seed the database
heroku run rails db:migrate
heroku run rails db:seed

# Precompile assets so images/css/js is served correctly
heroku run bundle exec rake assets:precompile

# Open up the app (it may take a few minutes for the app-server/db to get ready after deploying)
heroku open
```

6. In case you need to wipe out the existing database (if say you want to re-seed it differently):
```sh
# Locally
heroku pg:reset DATABASE_URL

# Remotely on Heroku, give it a minute to finish the previous command
rails db:migrate
rails db:seed
```

## Deploying to AWS Elastic Beanstalk

1. [SSH into AWS EC2](#ssh-into-aws-ec2)
2. [From EC2, start Elastic Beanstalk](#from-ec2-start-elastic-beanstalk)
3. [Monitor EB from the AWS console in web browser](#monitor-eb-from-the-aws-console-in-web-browser)
4. [Seed the DB](#seed-the-db)
5. [Verify app works](#verify-app-works)

### SSH into AWS EC2

1. Download our secret key `luber.pem` from Piazza *(if don't have `luber.pem` already)* 

    - (Search [Piazza](https://piazza.com/class/j789lo09yai5qx) for `aws credentials luber` )

2. ssh into our EC2 instance
```sh
 ssh -i luber.pem luber@ec2.cs291.com
```

3. on EC2, make your own dir to launch EB from:
```sh    
mkdir Justin
cd Justin
```
4. clone our repo *(if not done already)*
```sh
git clone https://github.com/scalableinternetservices/Luber.git
cd Luber
```

### From EC2, start Elastic Beanstalk

- Ensure you're ssh'd into EC2 (see above)

- Ensure you're in your git repo

    - `git status` should not say "Not a git repository"

- Try to deploy EB: 
```sh
eb deploy luber-justin ( <-- your env name here)
```

- If `eb deploy` yields "No environment" error, need to `eb create`:

    - for 'hello world':
    ```sh
    eb create -db.engine postgres -db.i db.t2.micro -db.user u --envvars SECRET_KEY_BASE=866b90021b2c4a0ebc32571e4b2ca94a --single luber-justin
    ```

    - for Tsung testing:
    ```sh
    eb create -db.engine postgres -db.i db.m3.medium -db.user u --envvars SECRET_KEY_BASE=866b90021b2c4a0ebc32571e4b2ca94a -i m3.medium luber-justin
    ```

    - *Note*: `-db.i` (the db machine) can be one of
        - db.m3.medium
        - db.m3.large
        - db.m3.xlarge
        - db.m3.2xlarge
        - db.r3.large
        - db.r3.xlarge
        - db.r3.2xlarge
        - (you can use the c3-instance types if CPU bound)
        - [AWS docs on instance types](https://aws.amazon.com/ec2/instance-types/)

    - *Note*: `-i` (the app server) can be one of
        - m3.medium
        - m3.large
        - m3.xlarge
        - m3.2xlarge
        - c3.large
        - c3.xlarge
        - c3.2xlarge
        - c3.4xlarge            
        - [AWS docs on instance types](https://aws.amazon.com/ec2/instance-types/)

    - **Note**: `SECRET_KEY_BASE` (base of key that encrypts cookies) should be long alphanumeric string, for example from
    ```sh
    head -c 100 </dev/urandom | hexdump | head -n 1 | cut -d" " -f2- | tr -d " "
    ```

- If `eb create` yields error "has not been set up with the EB CLI", need to `eb init`, then do `eb create` again:
```sh
eb init
```

    - IMPORTANT: "Select region", use the default. Otherwise the keypairs won't show up later.
    - "Select an application to use": make a new one, with your name ("luber-justin")
    - Select a keypair: 'luber' (your team name)

- `eb use luber-justin` to make this your default (later can use `eb list` to see list of deployments).

    - When you update the code, can do `eb deploy` instead of `eb create` -- faster.

- Output from `eb deploy` or `eb create`:
```
Creating application version archive "app-541a-171128_215113".
Uploading luber-justin/app-541a-171128_215113.zip to S3. This may take a while.
Upload Complete.
Environment details for: luber-justin
  Application name: luber-justin
  Region: us-west-2
  Deployed Version: app-541a-171128_215113
  Environment ID: e-zwqrwahpna
  Platform: arn:aws:elasticbeanstalk:us-west-2::platform/Puma with Ruby 2.4 running on 64bit Amazon Linux/2.6.1
  Tier: WebServer-Standard
  CNAME: UNKNOWN
  Updated: 2017-11-28 21:51:17.422000+00:00
Printing Status:
INFO: createEnvironment is starting.
INFO: Using elasticbeanstalk-us-west-2-671946291905 as Amazon S3 storage bucket for environment data.
INFO: Created security group named: awseb-e-zwqrwahpna-stack-AWSEBSecurityGroup-WY9IFP478JLS
INFO: Created EIP: 54.191.49.249
INFO: Creating RDS database named: aa3e7jh8yi6knq. This may take a few minutes.
```

### Monitor EB from the AWS console in web browser

1. Log in: 

    - [AWS console](https://console.aws.amazon.com/console/home)
    - Account ID or alias: `bboe-ucsb`
    - IAM user name: luber
    - password: contained in the file `luber@ec2.cs291.com:~/luber.txt`

2. Under `Menu` > `Services` > `Elastic Beanstalk` > `All Applications`, see your EB deployment name, eg, `luber-justin`. Click it to get to its dashboard.

3. When it's finished deploying, see the tiny URL near the top. Visit it in a web browser to verify it works.

### Seed the DB

1. SSH into the app server and go to the rails installation:
```sh
EC2$ eb ssh -e 'ssh -i ~/luber.pem'
APP-SERVER$ cd /var/app/current
```
2. On the app server's rails installation, delete contents of db and re-seed:
```sh           
APP-SERVER$ date ; echo 'ActiveRecord::Base.logger.level = 1 ; Tagging.delete_all ; Rental.delete_all ; Tag.delete_all ; Car.delete_all ;  User.delete_all ; ActiveRecord::Base.logger.level = 0' | rails c ; date
APP-SERVER$ rails db:seed
```

    - Note: `delete_all` doesn't obey foreign-key constraints, so is faster than `destroy_all`. 
    - Note: This didn't work:
    ```sh
    APP-SERVER$ DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:reset
    ```

### Verify app works

- Now your app should be populated with data.

## Load testing with Tsung

*(Note: Please use the `justin-tsung` branch for load-testing)*

1. [Quickstart](#quickstart)
2. [Run Tsung against your app](#run-tsung-against-your-app)
    1. [Use CloudFormation to create a Tsung machine and SSH into it](#use-cloudformation-to-create-a-tsung-machine-and-ssh-into-it)
    2. [Copy XML files to Tsung](#copy-xml-files-to-tsung)
    3. [Run Tsung](#run-tsung)
    4. [Download Tsung data](#download-tsung-data)
3. [Rapid reset for another Tsung test](#rapid-reset-for-another-tsung-test)

### Quickstart 

*(if you know what you're doing)*

1. Log in to EC2
```sh
ssh -i luber.pem luber@ec2.cs291.com
```

2. `cd` to Luber in your personal directory

3. Start our app on Elastic Beanstalk:
```sh
EC2$ git pull
EC2$ eb deploy # if it's still running, or 'eb create ...' if not.
```

4. Seed the db:
```sh
EC2$ eb ssh -e 'ssh -i ~/luber.pem'
```
    - Now you're in the production machine (the App Server). Delete all the db's data (note: order you delete the models is imporant to avoid foreign key errors):
    ```sh
    APP-SERVER$ cd /var/app/current
    APP-SERVER$ date ; echo 'ActiveRecord::Base.logger.level = 1 ; Tagging.delete_all ; Rental.delete_all ; Tag.delete_all ; Car.delete_all ; User.delete_all ; ActiveRecord::Base.logger.level = 0' | rails c ; date
    APP-SERVER$ rails db:seed
    ```

5. In [AWS CloudFormation](https://us-west-2.console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/), make a new stack for Tsung

6. In Options, use ssh command to ssh into Tsung machine

7. Copy XML to Tsung:
```sh
rsync -auvLe 'ssh -i luber.pem' *.xml ec2-user@52.41.232.150:~
```

8. Run Tsung:
```sh
tsung -f simple.xml -k start
```

9. Save XML from Tsung:
```sh
rsync -auvLe 'ssh -i demo.pem' ec2-user@54.166.5.220:~ .
```

### Run Tsung against your app

- This part assumes your app is already running on Elastic Beanstalk, see [Launch your app on Elastic Beanstalk](#launch-your-app-on-elastic-beanstalk)

#### Use CloudFormation to create a Tsung machine and SSH into it

1. Visit [AWS CloudFormation](https://us-west-2.console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new)

    - Account ID or Alias: `bboe-ucsb`
    - IAM user name: luber
    - Password: see `luber@ec2.cs291.com:~/luber.txt`

2. Use for the "S3 template URL": https://cs291.s3.amazonaws.com/Tsung.json

3. Pick a Stack Name of the form `luber-justin`.

4. App instance type: m3.medium

5. Team name (pulldown): luber

6. "Next", "Next", "Create"
    - You should now be at the CloudFormation "Stacks" page.

7. If your Stack Name doesn't appear in the table, refresh after a couple secs.

8. Should see "CREATE_IN_PROGRESS" under Status. Wait until created.

9. Check your Stack Name, then under "Outputs" tab:

    1. Note the **Tsung IP address**.
    2. Use the SSH cmd to log in to the EC2 Tsung machine (from a fresh terminal, don't need to do it from EC2). 
    3. Open the Tsung IP addr in browser tab to see the **Tsung Dashboard**.

10. In the ssh session, see `simple.xml`, our tsung test.
    - This machine will be destroyed after 45 inactive minutes, so if you edit `simple.xml` be sure to `rsync` it to your local machine.

11. In the Tsung file `simple.xml` change the line 

        server host="www.google.com" 

    to the AWS EB URL where your app is running. (See the AWS Console > Elastic Beanstalk > your deployed app.)

    Example:
    ```xml
    <servers>
        <server host="luber-justin.dckugbigqr.us-west-2.elasticbeanstalk.com" port="80" type="tcp"></server>
    </servers> 
    ```

#### Copy XML files to Tsung
```sh
my-laptop$ cd your-tsung-xmls/
my-laptop$ rsync -auvLe 'ssh -i luber.pem' *.xml ec2-user@52.41.232.150:~
```

Note: When ssh'd into the Tsung machine, `ifconfig` lists some weird IP addr, this is NOT the IP to use. Use the IP from the browser's Tsung dashboard, found in [CloudFormation](https://us-west-2.console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/).

#### Run Tsung

1. Start Tsung
```sh
tsung -f simple.xml -k start
```

2. (Tsung runs.)

3. See the Tsung dashboard. Neato.

#### Download Tsung data

1. When Tsung is finished, `rsync` over the logs & data to your local machine:
```sh
rsync -auvLe 'ssh -i demo.pem' ec2-user@54.166.5.220:tsung_logs .
```

2. Don't put tsung data into our repo, you'll probably want to experiment with Tsung. Maybe put each log into a folder with a README of which commit hash code you ran in EB, and which Tsung file you used, and how you changed the site (vertical / horiz scaling etc) to accommodate the load.

### Rapid reset for another Tsung test

1. Make new Tsung XML file 
2. Change DB machine & # instances
    - AWS elastic beanstalk > all applications > luber > luber-michael > sidebar > configuration
    - Can change instance type / number of instances on the fly, don't have to restart EB (no `eb create` etc)
    - Note: Bryce said no load balancer. Fix # instnaces to max of what you'll need.
3. Change seed file (more users, cars, rentals, etc)
    - Lives on app server, `/var/app/current/db/seeds.rb`.
    - Re-seed the db, see: [Seed the DB](seed-the-db)
4. Change code (like try Rails caching, see class notes)

## Tips

- Note: sometimes AWS EB console can warn you that you're overloading it:
```
Time    Type    Details
2017-11-28 14:43:20 UTC-0800    INFO    Environment health has transitioned from Severe to Ok.
2017-11-28 14:40:21 UTC-0800    WARN    Environment health has transitioned from Ok to Severe. 44.8 % of the requests are failing with HTTP 5xx.
```

- Bryce's Advice re: tsung testing, Nov 30, 2017:

    - no autoscaling: fix # instances
    - puma log file - where?
    - aws console can download .zip logs.
    - turn off foreign key check when deleting (somehow)
    - verify no logs written to disk (slows stuff down?)
    - put each flow into a transactions; then it'll plot nicely and plot different flows
    - duration of each session not that important: what's important is the max number of users/sec that can be arriving at your site.
    - as soon as http status 500's start coming in, your data is invalid: your response times will be artificially short bc a 500 happens quick.

## References

- [README from Bryce's 'demo' repo](https://github.com/scalableinternetservices/demo_rails514_beanstalk)

- [CS 291 slides on Tsung load-testing](http://cs291.com/slides/2017/11_tsung/#9)
        
- [Piazza - Elastic Beanstalk Instructions](https://piazza.com/class/j789lo09yai5qx?cid=45)

- [Piazza - AWS Credentials](https://piazza.com/class/j789lo09yai5qx?cid=42)

## Team Members

Sujaya Maiyya ([@sujaya](https://github.com/sujaya))
<p align="center">
  <img height="300px" src="https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/sujaya.png" alt="Sujaya Maiyya Photo">
</p>

Sammy Guo ([@masoug](https://github.com/masoug))  
<p align="center">
  <img height="300px" src="https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/sammy.png" alt="Sammy Guo Photo">
</p>

Kyle Carson ([@carsonkk](https://github.com/carsonkk))  
<p align="center">
  <img height="300px" src="https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/kyle.png" alt="Kyle Carson Photo">
</p>

Justin Pearson ([@justinpearson](https://github.com/justinpearson))  
<p align="center">
  <img height="300px" src="https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/justin.png" alt="Justin Pearson Photo">
</p>

Michael Zhang & Michael's little helper ([@Heronalps](https://github.com/Heronalps))  
<p align="center">
  <img height="300px" src="https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/michael.png" alt="Michael Zhang Photo">
</p>