class DashboardController < ApplicationController
  def index

  end

  def leaderboard
    @users = User.ranked

    @start_date = Time.new(2015, 5, 1)
    @end_date = Time.new(2015, 10, 1)

    @remaining = @end_date - Time.now
    @elapsed = Time.now - @start_date
    @duration = @end_date - @start_date
  end

  def stats
    @start_date = Time.new(2015, 5, 1)
    @end_date = Time.new(2015, 10, 1)

    @days = ((@end_date - @start_date) / 86400).round
    @day = ((Time.now - @start_date) / 86400).round

    @remaining = @end_date - Time.now
    @elapsed = Time.now - @start_date
    @duration = @end_date - @start_date

    @actitives = Activity.c2015
    @total = @actitives.sum(:distance)
    @total_time = @actitives.sum(:moving_time)
    @average = @total / @elapsed
    @average_speed = @total / @total_time
    @projection = @average * @duration
  end

  def graph
    @users = User.all.order('id ASC')

    if Time.now < Time.new(2015, 5, 1)
      # Preseason
      @start_date = Time.new(2014, 12, 1)
      @end_date = Time.new(2015, 5, 1)
    else
      # Regular season
      @start_date = Time.new(2015, 5, 1)
      @end_date = Time.new(2015, 10, 1)
    end

    @remaining = @end_date - Time.now
    @elapsed = Time.now - @start_date
    @duration = @end_date - @start_date

    @timestamps = {}
    # { 1428768000000: { 1: 5 } }
    # time : {uid: dist}

    for user in @users
      activities = user.activities.c2015.order(start_date: :asc)

      for activity in activities
        ms = activity.start_date.to_i

        @timestamps[ms] = {} if !@timestamps[ms]
        @timestamps[ms][user.id] = activity.distance / 1000
      end
    end
  end

  def athletes
    @athletes = User.all
  end
end
