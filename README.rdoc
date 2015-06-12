This rails app contains a rake command, `rake email_delivered_stories`, will send out an email whose content consists of
all the pivotal stories that have been marked as delivered since the last deployment of an app. This scrip works only when
provided a set of heroku environment variables:
`HEROKU_API_KEY` - a heroku api key that has acces to the heroku app you'd like to report on
`MAIN_APP_NAME` -  the name of the heroku app you'd like to report on
`EMAIL_RECIPIENT` - an email address recipient which is most likely an alias for a list of team members
`TRACKER_TOKEN` - a pivotal tracker api key that has access to projects that you'd like to report on


Example result email:
![alt text](http://vts-monosnap.s3.amazonaws.com/MailCatcher_2015-06-12_17-12-05.png)

