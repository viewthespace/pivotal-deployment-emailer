task :email_delivered_stories => :environment do
  reporter = DeliveredStoriesReport.new
  Rails.logger.info "Finding Delivered Stories"
  reporter.find_stories
  reporter.print_stories
  Rails.logger.info "Sending Email"
  reporter.email_report
  Rails.logger.info "Done"
end