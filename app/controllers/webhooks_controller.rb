class WebhooksController < ApplicationController
  def get
    mode = params['hub.mode']
    challenge = params['hub.challenge']
    token = params['hub.verify_token']

    if mode != 'subscribe' || token != 'STRAVA'
      render status: 400, text: nil
    else
      render status: 200, text: challenge
    end
  end

  def post

  end
end
