class Import < ActiveRecord::Base
  def self.import
    users = User.all
    activities = []

    for user in users
      client = ::Strava::Api::V3::Client.new(access_token: user.token)

      _activities = client.list_athlete_activities(per_page: 20)

      for activity in _activities
        _activity = Activity.find_by(strava_id: activity['id'])

        if _activity.nil?
          _activity = Activity.new(
            user_id: user.id,
            strava_id: activity['id'],
            strava_type: activity['type'],
            distance: activity['distance'],
            moving_time: activity['moving_time'],
            elapsed_time: activity['elapsed_time'],
            start_date: activity['start_date'],
            start_date_local: activity['start_date_local'],
            timezone: activity['timezone'],
            name: activity['name'],
            description: activity['description'],
          )
          _activity.save!
          activities << _activity
        end
      end
    end

    activities
  end
end
