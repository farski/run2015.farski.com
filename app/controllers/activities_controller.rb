class ActivitiesController < ApplicationController
  def index
    @activities = Activity.runs.order(start_date: :desc)
  end
end
