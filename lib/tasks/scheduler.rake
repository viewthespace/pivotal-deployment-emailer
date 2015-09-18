task :email_delivered_stories => :environment do
  reporter = DeliveredStoriesReport.new
  Rails.logger.info "Finding Delivered Stories"
  reporter.find_stories
  reporter.print_stories
  Rails.logger.info "Sending Email"
  reporter.email_report
  reporter.set_report_time
  reporter.set_reported_stories
  Rails.logger.info "Done"
end
