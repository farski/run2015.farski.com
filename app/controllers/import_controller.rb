class ImportController < ApplicationController
  def update
    @activities = Import.import

    notifier1 = Slack::Notifier.new(ENV['SLACK_PRX_WEBHOOK_URL'])
    notifier2 = Slack::Notifier.new(ENV['SLACK_REHEY_WEBHOOK_URL'])

    activities = @activities

    if activities.length > 0

      attachments = []

      for activity in activities

        if activity.distance > 12000
          color = "good"
        elsif activity.distance > 8000
          color = "warning"
        else
          color = "danger"
        end

        name = activity.user.label
        link = "https://www.strava.com/activities/#{activity.strava_id}"
        km = (activity.distance / 1000).round(2)
        ranking = activity.user.ranking

        moving_time = activity.moving_time
        duration = ActionController::Base.helpers.distance_of_time_in_words(Time.now, (Time.now + moving_time))

        if activity.strava_type == 'Run'
          attachments << {
            fallback: "#{name} just ran #{km}km in #{duration} and is in #{ranking.ordinalize} place.",
            text: "#{name} just ran <#{link}|#{km}km> in #{duration} and is in #{ranking.ordinalize} place.",
            color: color,
            thumb_url: "http://chart.googleapis.com/chart?cht=ls&chco=0077CC&chds=a&chs=75x20&chd=t:#{activity.user.sparklist.join(',')}"
          }
        end
      end

      if !attachments.empty?
        notifier1.ping '', attachments: attachments
        notifier2.ping '', attachments: attachments
      end
    end
  end
end
