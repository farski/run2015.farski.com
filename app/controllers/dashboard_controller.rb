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
      activities = user.activities.runs.p2015.order(start_date: :asc)

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
