class DashboardController < ApplicationController
  def index

  end

  def leaderboard
    @users = User.all

    @totals = {}

    @users.each do |user|
      @totals[user] = user.activities.runs.c2014.inject(0) { |sum, act| sum + act['distance'] }
    end
  end

  def graph
    foo = []

    for user in User.all
      data = []
      distance_t = 0

      activities = user.activities.runs.p2015.order(start_date: :asc)

      if params[:y] == '2014'
        activities = user.activities.runs.c2014.order(start_date: :asc)
      end

      for activity in activities
        distance_t += (activity[:distance] / 1000)

        y = activity[:start_date].year
        m = activity[:start_date].month - 1
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
