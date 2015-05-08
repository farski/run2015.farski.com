class ImportController < ApplicationController
  def update
    @activities = Import.import

    notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])

    totals = User.joins(:activities).group('"users"."id"').where(['"activities"."start_date_local" >= ?', Time.new(2015, 5, 1)]).where(['"activities"."start_date_local" < ?', Time.new(2015, 10, 1)]).where(%q|"activities"."strava_type" LIKE 'Run'|).order("sum_activities_distance DESC").sum('"activities"."distance"')
    ordered_ids = totals.keys

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

        name = "#{activity.user.forename} #{activity.user.surname[0]}."
        link = "https://www.strava.com/activities/#{activity.strava_id}"
        km = (activity.distance / 1000).round(2)
        ranking = ordered_ids.index(activity.user.id) + 1
        place = ActionController::Base.helpers

        moving_time = activity.moving_time
        duration = ActionController::Base.helpers.distance_of_time_in_words(Time.now, (Time.now + moving_time))

        attachments << {
          fallback: "#{name} just ran #{km}km in #{duration} and is in #{ranking.ordinalize} place.",
          text: "#{name} just ran <#{link}|#{km}km> in #{duration} and is in #{ranking.ordinalize} place.",
          color: color,
        }
      end

      notifier.ping '', attachments: attachments
    end
  end
end
