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
    _series = []

    if params[:y] == '2014'
      start_date = Time.new(2014, 5, 5)
      end_date = Time.new(2014, 9, 13)
    else
      # Preseason
      start_date = Time.new(2014, 12, 1)
      end_date = Time.new(2015, 5, 1)
    end

    now = Time.now
    t_remaining = end_date - now
    t_elapsed = now - start_date

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

      avg = distance_t / t_elapsed
      projected = (end_date - start_date) * avg

      pdata = []
      pdata << data.last
      y = end_date.year
      m = end_date.month - 1
      d = end_date.day
      pdata << "{x: Date.UTC(#{y}, #{m}, #{d}), y: #{projected}, color: '#FF0000'}"
      pobj = "{name: '(#{user.forename} #{user.surname[0]})', data: [#{pdata.join(',')}]}"

      _series << obj
      _series << pobj unless params[:y]
    end

    @series = _series.join(',')
  end

  def athletes
    @athletes = User.all
  end
end
