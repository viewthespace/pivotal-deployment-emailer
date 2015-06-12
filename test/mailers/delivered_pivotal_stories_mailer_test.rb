require 'test_helper'

class DeliveredPivotalStoriesMailerTest < ActionMailer::TestCase

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    test_story1 = PivotalTracker::Story. new
    test_story1.name = 'name'
    test_story1.story_type = 'feature'
    test_story1.requested_by = 'me'
    test_story1.created_at = DateTime.parse 'Jun 8 15:29:25 EDT 2015'

    test_story2 = PivotalTracker::Story. new
    test_story2.name = 'name'
    test_story2.story_type = 'feature'
    test_story2.requested_by = 'me'
    test_story2.created_at = DateTime.parse 'Jun 8 15:29:25 EDT 2015'

    test_stories = [test_story1, test_story2]

    DeliveredPivotalStoriesMailer. delivered_pivotal_stories_mailer(test_stories, 'Jun 8 15:29:25 EDT 2015').deliver!
  end

  def teardown
    assert ActionMailer::Base.deliveries.count == 1
  end

  test 'renders the receiver email' do
    assert ActionMailer::Base.deliveries.first.to == ['nathan.owen@viewthespace.com']
  end

  test 'should set the subject to the correct subject' do
    assert ActionMailer::Base.deliveries.first.subject == 'Updates Since Last Deployment'
  end

  test 'renders the sender email' do
    assert ActionMailer::Base.deliveries.first.from == ["no-reply@viewthespace.com"]
  end
end
