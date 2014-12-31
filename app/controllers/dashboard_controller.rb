class DashboardController < ApplicationController
  def index

  end

  def leaderboard
    foo = []

    for user in User.all
      data = []
      distance_t = 0

      activities = user.activities.runs.order(start_date: :asc).where(['start_date >= ?', Time.new(2014, 12, 1)]).where(['start_date < ?', Time.new(2015, 5, 1)])

      for activity in activities
        distance_t += (activity[:distance] / 1000)

        y = activity[:start_date].year
        m = activity[:start_date].month
        d = activity[:start_date].day
        data << "[Date.UTC(#{y}, #{m}, #{d}), #{distance_t.round(2)}]"
      end

      obj = "{name: '#{user.forename} #{user.surname[0]}', data: [#{data.join(',')}]}"

      foo << obj
    end

    @series = foo.join(',')
  end

  def athletes
    @athletes = User.all
  end
end
