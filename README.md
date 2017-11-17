# Luber: :oncoming_automobile: A Car-sharing App :oncoming_taxi:
[![Build Status](https://travis-ci.org/scalableinternetservices/Luber.svg?branch=master)](https://travis-ci.org/scalableinternetservices/Luber)
==================================

About
------

Sharing economy is efficient, environment-friendly and accessible to all. Uber and Airbnb have swept out the traditional rental business in every aspect. It's much faster and more convenient to ask for a ride by Uber or Lyft, however, sometimes a ride is not sufficient for all travelling demand, in case of family trip, long journey or private event. Therefore, We'd like to work on a Uber-like car-sharing app for CS291A project.

The app is basically a booking system, in which the car owners can post the availability of their car in terms of time, location, model, mileage, photo and price. On the flipping side, the car users can search in the same manner and app will find the best match for both side. At the reserved time and location, the user will pick up the car from the owner and return it, perhaps at another location. All transactions are made online and a rating and review system in app is for users and owners to build up their reputation across board.

This app will have a web version at first, and then derives to a mobile version afterwards.

[Piazza post](https://piazza.com/class/j789lo09yai5qx?cid=7)

Getting Started
----------------

1. Make sure Ruby, Rails, and any other tools (such as RVM) are installed and ready to go (click [here](http://installrails.com/steps/choose_os) for geenral installation instructions and [here](https://rvm.io/) for RVM)
2. Clone the repo
```sh
git clone git@github.com:scalableinternetservices/Luber.git
cd Luber
```
3. Setup the project and test that the server starts succesfully
```sh
bundle install --without production
# If you're on linux you may need to do the following to increase your number of watchers
# echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
rails db:migrate
rails s
# By default the server should start on http://localhost:3000/
```

Contributing
-------------

In order to contribute, complete the `Setup` section, then follow the general flow outlined below

1. Make sure the master branch builds and you can navigate around the site. Familiarize yourself with the codebase
2. Once you have a specific feature/issue you want to work on, create a new branch for that feature
```sh
git checkout -b my-feature-branch
git push origin my-feature-branch
```
3. Use test-driven development where applicable to create your new feature/resolve the given issue, and once thoroughly tested, submit a pull request on [GitHub](https://github.com/scalableinternetservices/Luber/pulls)
4. Once your code is peer-reviewd and any Travis CI issues are resolved, merge the branch into master

Team Members
-------------

Sujaya Maiyya ([@sujaya](https://github.com/sujaya))  
![sujaya photo](https://avatars2.githubusercontent.com/u/4294071?v=4&s=400)

Sammy Guo ([@masoug](https://github.com/masoug))  
![masoug photo](https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/sammy.jpg)

Kyle Carson ([@carsonkk](https://github.com/carsonkk))  
![carsonkk photo](https://avatars0.githubusercontent.com/u/10569071?v=4&s=400)

Justin Pearson ([@justinpearson](https://github.com/justinpearson))  
![justinpearson photo](http://justinppearson.com/assets/my-face-2.png)

Michael Zhang & Michael's little helper([@Heronalps](https://github.com/Heronalps))  
![Heronalps photo](https://github.com/scalableinternetservices/Luber/blob/master/misc/snapshots/heronalps.jpg)


How to run load-tests with Tsung
----------------------------------

See <http://cs291.com/slides/2017/11_tsung/#1>, slide 9/34.

### Recall your AWS username and password

SSH into our Elastic Beanstalk (EB) EC2 instance using the provided TEAMNAME.pem file:

    ssh -i TEAMNAME.pem TEAMNAME@ec2.cs291.com

Our AWS username and pw is in `~/TEAMNAME_key.txt`.

WARNING: Never commit this credentials into your repository, or put them anywhere else that they might be made public.


### Deploy Tsung on a m3.medium instance using CloudFormation

1. Visit AWS CloudFormation: https://us-west-2.console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new

    - Account ID or Alias: `bboe-ucsb`
    - IAM user name: see above
    - Password: see above

1. Use for the "S3 template URL": https://cs291.s3.amazonaws.com/Tsung.json

1. Pick a Stack Name of the form `luber-michael`.

1. App instance type: m3.medium

1. Team name (pulldown): luber

1. "Next", "Next", "Create"

    - You should now be at the CloudFormation "Stacks" page.

1. If your Stack Name doesn't appear in the table, refresh after a couple secs.

1. Should see "CREATE_IN_PROGRESS" under Status.

1. Check your Stack Name, then under "Outputs" tab, use the SSH cmd to log in to the EC2 Tsung machine. Also, open the IP addr in another browser tab.

1. In the ssh session, see `simple.xml`, our tsung test.

    - This machine will be destroyed after 45 inactive minutes, so if you edit `simple.xml` be sure to `rsync` it to your local machine.


1. In the Tsung file `simple.xml` change the line `server host="www.google.com"` to the AWS EB URL where our app is running (to find that, see below)

### Start Elastic Beanstalk

- See <https://github.com/scalableinternetservices/demo_rails514_beanstalk>

- Note: In the EC2 instance where we start EB with `eb init`, make your own directory, `git clone` our repo, set up EB so that `eb init` works, and then you can start your own EB instance without stepping on your teammates' toes.

### Start Tsung test

1. With EB started, go to the EB dashboard and get the URL where EB is hosting your site.

1. Paste that URL into the `server host=` field of `simple.xml`.

1. In simple.xml, define a 'session' (a flow of user going thru the site)

1. Start Tsung:

    tsung -f simple.xml -k start

1. (Tsung runs.)

1. In the browser tab for the Tsung EC2 instance (got from Options tab earlier)

1. See the Tsung dashboard. Neato.

1. When Tsung is finished, `rsync` over the logs & data to your local machine:

    rsync -auvLe 'ssh -i demo.pem' ec2-user@54.166.5.220:tsung_logs .

1. Don't put tsung data into our repo, you'll probably want to experiment with Tsung. Maybe put each log into a folder with a README of which commit hash code you ran in EB, and which Tsung file you used, and how you changed the site (vertical / horiz scaling etc) to accommodate the load.

1. To vary the # instances in EB and their size: 

    - AWS elastic beanstalk > all applications > luber > luber-michael > sidebar > configuration
    - can change instance type / number of instances on the fly, don't have to restart EB

1. Try out a bunch of things!
