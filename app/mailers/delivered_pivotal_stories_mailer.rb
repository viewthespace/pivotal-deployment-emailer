class DeliveredPivotalStoriesMailer < ActionMailer::Base
  default from: "no-reply@viewthespace.com"

  def delivered_pivotal_stories_mailer new_stories, date_string
    @new_stories = new_stories
    @time_of_last_report = DateTime.parse(date_string).strftime("%m/%d/%y")
    if new_stories.present?
      attach_images
      mail(to: ENV["EMAIL_RECIPIENT"] , subject: "Production releases since #{@time_of_last_report}")
    elsif ENV["BACKUP_EMAIL"].present?
      mail(to: ENV["BACKUP_EMAIL"],
           subject: "No delivered stories since #{@time_of_last_report} to report",
           body: "No stories were marked as delivered by the most recent report on #{@time_of_last_report}."\
           "You alone received this email because it was marked as the backup email on the pivotal-deployment-emailer app.")
    end
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
