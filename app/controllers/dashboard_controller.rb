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

  def graph2
    if params[:y] == '2014'
      start_date = Time.new(2014, 5, 5)
      end_date = Time.new(2014, 9, 13)
    else
      # Preseason
      start_date = Time.new(2014, 12, 1)
      end_date = Time.new(2015, 5, 1)
      # Regular season
      # start_date = Time.new(2015, 5, 1)
      # end_date = Time.new(2015, 10, 1)
    end

    now = Time.now
    t_total = end_date - start_date
    t_remaining = end_date - now
    t_elapsed = now - start_date

    progress = t_elapsed / t_total
    _data_zoom_end = progress * 100 + 10
    @data_zoom_end = _data_zoom_end > 100 ? 100 : _data_zoom_end

    @_legend_data = []
    @_series = []

    for user in User.all
      @_legend_data << "'#{user.forename.capitalize} #{user.surname[0].capitalize}'"

      _series_data = []
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
        h = activity[:start_date].hour
        n = activity[:start_date].min
        _series_data << "[new Date(#{y}, #{m}, #{d}, #{h}, #{n}), #{distance_t.round(2)}]"
      end

      y = end_date.year
      m = end_date.month - 1
      d = end_date.day
      h = 23
      n = 59
      avg = distance_t / t_elapsed
      projected = (end_date - start_date) * avg
      _series_data << "[new Date(#{y}, #{m}, #{d}, #{h}, #{n}), #{projected.round(2)}]"\

      series_data = "[#{_series_data.join(',')}]"

      series_obj = '{'
      series_obj += "name:'#{user.forename.capitalize} #{user.surname[0].capitalize}', "
      series_obj += "type:'line', "
      series_obj += "symbol: 'none', "
      series_obj += "data: #{series_data}"
      series_obj += '}'

      @_series << series_obj
    end

    @legend_data = @_legend_data.join(',')
    @series = "[#{@_series.join(',')}]"
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
      # Regular season
      # start_date = Time.new(2015, 5, 1)
      # end_date = Time.new(2015, 10, 1)
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

      obj = "{name: '#{user.forename.capitalize} #{user.surname[0].capitalize}', data: [#{data.join(',')}]}"

      if data.last
        avg = distance_t / t_elapsed
        projected = (end_date - start_date) * avg

        pdata = []
        pdata << data.last
        y = end_date.year
        m = end_date.month - 1
        d = end_date.day
        pdata << "{x: Date.UTC(#{y}, #{m}, #{d}), y: #{projected.round(2)}, color: '#FF0000'}"
        pobj = "{name: '(#{user.forename} #{user.surname[0]})', data: [#{pdata.join(',')}], linkedTo: ':previous'}"
      end

      _series << obj
      _series << pobj if pobj
    end

    @series = _series.join(',')
  end

  def athletes
    @athletes = User.all
  end
end
