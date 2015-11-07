class Relay
  def notifiers
    [
      Slack::Notifier.new(ENV['SLACK_PRX_WEBHOOK_URL']),
      Slack::Notifier.new(ENV['SLACK_REHEY_WEBHOOK_URL'])
    ]
  end

  def notify(attachments)
    notifiers.each do |notifier|
      notifier.ping "", attachments: attachments
    end
  end

  def run
    users = User.all
    attachments = users.each_with_object([]) do |user, memo|
      client = user.strava_client
      timestamp = Time.now.yesterday.to_i
      activities = client.list_athlete_activities(after: timestamp)
      memo.concat(process_activites(user, activities))
    end
    notify(attachments)
  end

  def process_activites(user, activities)
    activities.map do |activity|
      process_activity(user, activity)
    end.compact
  end

  # Returns the attachment for this activity
  def process_activity(user, json)
    activity = Activity.find_by(strava_id: json['id'])

    if activity.nil?
      activity = Activity.new(
        user_id: user.id,
        strava_id: json['id'],
        strava_type: json['type'],
        distance: json['distance'],
        moving_time: json['moving_time'],
        elapsed_time: json['elapsed_time'],
        start_date: json['start_date'],
        start_date_local: json['start_date_local'],
        timezone: json['timezone'],
        name: json['name'],
        description: json['description'],
      )
      activity.save!

      activity.to_attachment
    end
  end
end
