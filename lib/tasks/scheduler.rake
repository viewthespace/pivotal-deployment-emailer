task :email_delivered_stories => :environment do
  reporter = DeliveredStoriesReport.new
  puts "Finding Delivered Stories"
  stories = reporter.find_stories
  reporter.print_stories
  puts "Sending Email"
  reporter.email_report
  puts "Done"
end