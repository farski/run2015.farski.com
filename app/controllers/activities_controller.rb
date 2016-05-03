class ActivitiesController < ApplicationController
  def index
    @activities = Activity.runs.c2016.order(start_date: :desc)
  end

  def scores
    @users = User.all
  end
end
