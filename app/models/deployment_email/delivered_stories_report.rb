module DeliveredStoriesReport

  def get_time_of_last_deployment
    unless (app_name = ENV["MAIN_APP_NAME"]).nil?
      require 'heroku-api'

      heroku  = Heroku::API.new(:api_key => ENV["HEROKU_API_KEY"])
      heroku.get_releases(app_name).body.last['created_at']
    else
      dummy_date = 'Jun 8 15:29:25 EDT 2015'
    end
  end

  def get_pivotal_api_token
    unless (pivotal_api_token = ENV['TRACKER_TOKEN']).nil?
      pivotal_api_token
    else
      dummy_api_token = '8b1e5decd74a12e824ae003febcb10ac'
    end
  end

  def find_stories date_string, pivotal_api_token
    puts "Date of last deployment: " + date_string
    time_of_last_deployment = DateTime.parse(date_string)
    PivotalTracker::Client.token =  pivotal_api_token
    PivotalTracker::Client.use_ssl = true

    projects = PivotalTracker::Project.all
    new_stories = []

    projects.each do |project|
      unless ["Android APP", "IOS APP", "iOS app-BAK", "Mobile Backend"].include? project.name
        puts "Gathering stories for " + project.name
        new_stories += project.stories.all(:state => 'delivered', :modified_since => time_of_last_deployment.to_s)
      end
    end
    new_stories
  end

  def print_stories stories
    puts "\nDelivered stories updated since last deployment"
    stories.each {|story| puts "  " + story.name}
  end

  def email_report stories, deployment_date
    DeliveredPivotalStoriesMailer.delivered_pivotal_stories_mailer(stories, deployment_date).deliver!
  end

end


