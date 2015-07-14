This rails app contains a rake command, `rake email_delivered_stories`, will send out an email whose content consists of
all the pivotal stories that have been marked as delivered since the last deployment of an app. It keeps track of 'last deployment'
by using redis to store the last time that such a report was sent out.
* `EMAIL_RECIPIENT` - an email address recipient which is most likely an alias for a list of team members
* `BACKUP_EMAIL` - an email address recipient that is emailed when there are no stories to report (as to not annoy everyone on a team)
* `TRACKER_TOKEN` - a pivotal tracker api key that has access to projects that you'd like to report on
* `MANDRILL_USERNAME` - the username of your favorite email client
* `MANDRILL_PASSWORD` - the password of your favorite email client (if you want to use something other than mandrill to send you emails for you, you'll have to change those configurations yourself in config/environments/production.rb

To use this command in another app, ideally as a part of another app's deployment script, you use `heroku run`.
For instance `heroku run rake email_delivered_stories --app pivotal-deployment-emailer`


Example result email:
![alt text](http://vts-monosnap.s3.amazonaws.com/Production_releases_since_071315_-_nathan.owenviewthespace.com_-_VTS_Mail_2015-07-14_10-35-36.png)

