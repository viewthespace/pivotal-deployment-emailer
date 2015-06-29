class DeliveredStoriesReport

  def find_stories
    time_of_last_deployment = DateTime.parse(get_time_of_last_deployment)
    PivotalTracker::Client.token =  get_pivotal_api_token
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

  def get_time_of_last_deployment
    app_name = ENV["MAIN_APP_NAME"]
    heroku  = Heroku::API.new(:api_key => ENV["HEROKU_API_KEY"])
    @deployment_date = 'Jun 8 15:29:25 EDT 2015'#heroku.get_releases(app_name).body.last['created_at']
  end

  def get_pivotal_api_token
    @pivotal_api_token = '8b1e5decd74a12e824ae003febcb10ac'#ENV['TRACKER_TOKEN']
  end

  def print_stories
    puts "\nDelivered stories updated since last deployment"
    @new_stories.each {|story| puts "  " + story.name}
  end

  def email_report
    DeliveredPivotalStoriesMailer.delivered_pivotal_stories_mailer(@new_stories, @deployment_date).deliver!
  end

end


