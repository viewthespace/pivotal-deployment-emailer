class DeliveredStoriesReport

  def find_stories
    time_of_last_deployment = DateTime.parse(time_of_last_report_string)
    PivotalTracker::Client.token =  pivotal_api_token
    PivotalTracker::Client.use_ssl = true
    projects = PivotalTracker::Project.all

    @new_stories =
      projects.map do |project|
        unless ["android", "ios", "mobile"].any? {|keyword| project.name.downcase.include? keyword}
          Rails.logger.info "Gathering stories for " + project.name
          project.stories.all(:state => 'delivered', :modified_since => time_of_last_deployment.to_s)
        end
      end.flatten!.compact
  end

  def time_of_last_report_string
    @report_datetime = $redis.get('time_of_last_report')
    $redis.set('time_of_last_report')
    @report_datetime
  end

  def version_name
    app_name = ENV["MAIN_APP_NAME"]
    heroku  = Heroku::API.new(:api_key => ENV["HEROKU_API_KEY"])
    heroku.get_releases(app_name).body.last['name']
  end

  def pivotal_api_token
    @pivotal_api_token = ENV['TRACKER_TOKEN']
  end

  def print_stories
    Rails.logger.info "Delivered stories updated since last deployment:"
    @new_stories.each {|story| Rails.logger.info "  " + story.name}
  end

  def email_report
    DeliveredPivotalStoriesMailer.delivered_pivotal_stories_mailer(@new_stories, @report_datetime, version_name).deliver!
  end

end


