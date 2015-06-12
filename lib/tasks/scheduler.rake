task :email_delivered_stories => :environment do
  require 'deployment_email/delivered_stories_report.rb'
  include DeliveredStoriesReport
  puts "Finding Delivered Stories"
  deployment_date = get_time_of_last_deployment
  stories = find_stories deployment_date, get_pivotal_api_token
  print_stories stories
  puts "Sending Email"
  email_report stories, deployment_date
  puts "Done"
end