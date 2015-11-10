class StravaActivity
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def user
    @user ||= StravaAthlete.new(data['athlete'])
  end

  def distance
    @distance ||= data['distance']
  end

  def km
    @km ||= (distance / 1000).round(2)
  end

  def moving_time
    @moving_time ||= data['moving_time']
  end

  def duration_in_words
    @duration_in_words ||= ActionController::Base.helpers.distance_of_time_in_words(Time.now, (Time.now + moving_time))
  end

  def strava_id
    @strava_id ||= data['id']
  end

  def strava_url
    @strava_url ||= "https://www.strava.com/activities/#{strava_id}"
  end

  def strava_type
    @strava_type ||= data['type']
  end

  def to_attachment
    return unless strava_type == 'Run'

    {
      fallback: "#{user.label} just ran #{km}km in #{duration_in_words}.",
      text: "#{user.label} just ran <#{strava_url}|#{km}km> in #{duration_in_words}.",
      color: attachment_color
      # thumb_url: "http://chart.googleapis.com/chart?cht=ls&chco=0077CC&chds=a&chs=75x20&chd=t:#{user.sparklist.join(',')}"
    }
  end

  private

  def attachment_color
    case distance
    when 0...8000
      "danger"
    when 8000...12000
      "warning"
    else
      "good"
    end
  end
end
