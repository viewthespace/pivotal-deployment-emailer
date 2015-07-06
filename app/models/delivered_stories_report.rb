class DeliveredStoriesReport

  def find_stories
    time_of_last_deployment = DateTime.parse(time_of_last_deployment_string)
    PivotalTracker::Client.token =  pivotal_api_token
    PivotalTracker::Client.use_ssl = true
    projects = PivotalTracker::Project.all

    @new_stories =
      projects.map do |project|
        unless ["android", "ios", "mobile"].any? {|keyword| project.name.downcase.include? keyword}
          puts "Gathering stories for " + project.name
          project.stories.all(:state => 'delivered', :modified_since => time_of_last_deployment.to_s)
        end
      end.flatten!.compact
  end

  def time_of_last_deployment_string
    app_name = ENV["MAIN_APP_NAME"]
    heroku  = Heroku::API.new(:api_key => ENV["HEROKU_API_KEY"])
    @deployment_name = heroku.get_releases(app_name).body.last['name']
    @deployment_date = heroku.get_releases(app_name).body.last['created_at']
  end

  def pivotal_api_token
    @pivotal_api_token = ENV['TRACKER_TOKEN']
  end

  def print_stories
    puts "\nDelivered stories updated since last deployment"
    @new_stories.each {|story| puts "  " + story.name}
  end

  def email_report
    DeliveredPivotalStoriesMailer.delivered_pivotal_stories_mailer(@new_stories, @deployment_date, @deployment_name).deliver!
  end

end


