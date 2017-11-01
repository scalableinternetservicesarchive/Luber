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
