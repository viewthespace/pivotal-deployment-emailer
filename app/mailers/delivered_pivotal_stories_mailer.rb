class DeliveredPivotalStoriesMailer < ActionMailer::Base
  default from: "no-reply@viewthespace.com"

  def delivered_pivotal_stories_mailer new_stories, date_string
    attach_images
    @new_stories = new_stories
    @time_of_last_deployment = DateTime.parse(date_string)
    unless (email_recipient = ENV["EMAIL_RECIPIENT"]).nil?
      mail(to: email_recipient , subject: 'Updates Since Last Deployment')
    else
      mail(to: 'nathan.owen@viewthespace.com' , subject: 'Updates Since Last Deployment')
    end
  end

  def attach_images
    attachments.inline['bug'] = {:data => File.read('app/assets/images/bug.png'),
                                 :mime_type => "image/png"}
    attachments.inline['chore'] = {:data => File.read('app/assets/images/chore.png'),
                                   :mime_type => "image/png"}
    attachments.inline['feature'] = {:data => File.read('app/assets/images/feature.png'),
                                     :mime_type => "image/png"}
    attachments.inline['release'] = {:data => File.read('app/assets/images/release.png'),
                                     :mime_type => "image/png"}
  end

end
