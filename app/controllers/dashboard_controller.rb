class DashboardController < ApplicationController
  def index

  end

  def athletes
    @athletes = User.all
  end
end
