class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    client = ::Strava::Api::V3::Client.new(access_token: @user.token)

    start2014 = 1399248000
    end2014 = 1410566400

    @activities2014 = client.list_athlete_activities(after: start2014, before: end2014, per_page: 200)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
