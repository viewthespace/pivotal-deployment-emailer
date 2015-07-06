class DeliveredPivotalStoriesMailer < ActionMailer::Base
  default from: "no-reply@viewthespace.com"

  def delivered_pivotal_stories_mailer new_stories, date_string, version_name
    attach_images
    @new_stories = new_stories
    @time_of_last_deployment = DateTime.parse(date_string).strftime("%m/%d/%y")
    @version_name = version_name
    mail(to: ENV["EMAIL_RECIPIENT"] , subject: "Updates Since Last Deployment on #{@time_of_last_deployment}")
  end

  def attach_images
    attachments.inline['bug'] =
        {:data => File.read('app/assets/images/bug.png'),
         :mime_type => "image/png"}
    attachments.inline['chore'] =
        {:data => File.read('app/assets/images/chore.png'),
         :mime_type => "image/png"}
    attachments.inline['feature'] =
        {:data => File.read('app/assets/images/feature.png'),
         :mime_type => "image/png"}
    attachments.inline['release'] =
        {:data => File.read('app/assets/images/release.png'),
         :mime_type => "image/png"}
  end

end
