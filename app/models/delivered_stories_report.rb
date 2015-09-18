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
      end.flatten!.compact.reject{ |s| REDIS.sismember "reported_stories", s.id.to_s }
  end

  def time_of_last_report_string
    REDIS.get('time_of_last_report')
  end

  def set_report_time
    REDIS.set('time_of_last_report', Time.now.to_s)
  end


  def set_reported_stories
     REDIS.sadd("reported_stories", reported_story_ids) if reported_story_ids.any?
  end

  def pivotal_api_token
    @pivotal_api_token = ENV['TRACKER_TOKEN']
  end

  def print_stories
    Rails.logger.info "Delivered stories updated since last deployment:"
    @new_stories.each {|story| Rails.logger.info "  " + story.name}
  end

  def email_report
    DeliveredPivotalStoriesMailer.delivered_pivotal_stories_mailer(@new_stories, time_of_last_report_string).deliver!
  end

  private

  def reported_story_ids
    @new_stories.collect(&:id)
  end

end


