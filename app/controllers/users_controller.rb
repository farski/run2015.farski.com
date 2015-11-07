class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.order(:id)
  end

  def show
    @activities = @user.runs.c2015.order(:start_date)

    @avg_distance = @user.runs.c2015.average(:distance)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
