class Activity < ActiveRecord::Base
  belongs_to :user

  scope :runs, -> { where(strava_type: 'Run') }
  scope :fortnight, -> { runs.where(['start_date_local >= ?', 14.days.ago]).where(['start_date_local <= ?', Time.now]) }
  scope :c2014, -> { runs.where(['start_date_local >= ?', Time.new(2014, 5, 5)]).where(['start_date_local <= ?', Time.new(2014, 9, 12)]) }
  scope :p2015, -> { runs.where(['start_date_local >= ?', Time.new(2014, 12, 1)]).where(['start_date_local < ?', Time.new(2015, 5, 1)]) }
  scope :c2015, -> { runs.where(['start_date_local >= ?', Time.new(2015, 5, 1)]).where(['start_date_local < ?', Time.new(2015, 10, 1)]) }
  scope :c2016, -> { runs.where(['start_date_local >= ?', Time.new(2016, 5, 1)]).where(['start_date_local < ?', Time.new(2016, 10, 1)]) }

  def km
    @km ||= (distance / 1000).round(2)
  end

  def score
    base = 100
    long = distance > 8000 ? 10 : 0
    xlong = distance > 12800 ? 15 : 0

    seven_days_ago = start_date - 7.days
    week_runs = user.mruns.select {|r| r.start_date > seven_days_ago && r.start_date < start_date && r.moving_time > 20.minutes}
    week = [20, ((20 / 6) * week_runs.count)].min

    fourteen_days_ago = start_date - 14.days
    fn_runs = user.mruns.select {|r| r.start_date > fourteen_days_ago && r.start_date < start_date && r.moving_time > 20.minutes}
    fn = [30, ((30 / 12) * fn_runs.count)].min

    month_ago = start_date - 30.days
    mon_runs = user.mruns.select {|r| r.start_date > month_ago && r.start_date < start_date && r.moving_time > 20.minutes}
    mon = [50, ((50 / 26) * mon_runs.count)].min

    bonus = [long, xlong, week, fn, mon].reduce(:+)
    bonus = [bonus, 100].min
    bonus = 0 if moving_time < 20.minutes

    base = 66 if moving_time < 10.minutes

    [base, bonus].reduce(:+)
  end

  def duration_in_words
    @duration_in_words ||= ActionController::Base.helpers.distance_of_time_in_words(Time.now, (Time.now + moving_time))
  end

  def strava_url
    @strava_url ||= "https://www.strava.com/activities/#{strava_id}"
  end

  def to_attachment
    return unless strava_type == 'Run'

    {
      fallback: "#{user.label} just ran #{km}km in #{duration_in_words}.",
      text: "#{user.label} just ran <#{strava_url}|#{km}km> in #{duration_in_words}.",
      color: attachment_color,
      thumb_url: "http://chart.googleapis.com/chart?cht=ls&chco=0077CC&chds=a&chs=75x20&chd=t:#{user.sparklist.join(',')}"
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
