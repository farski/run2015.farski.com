class Notifier
  def self.notifiers
    [
      # Slack::Notifier.new(ENV['SLACK_PRX_WEBHOOK_URL']),
      Slack::Notifier.new(ENV['SLACK_REHEY_WEBHOOK_URL'])
    ]
  end

  def self.post_activity(activity)
    notifiers.each do |notifier|
      notifier.ping "", attachments: [activity.to_attachment]
    end
  end
end
