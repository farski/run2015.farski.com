class WebhooksController < ApplicationController
  def get
    mode = params['hub.mode']
    challenge = params['hub.challenge']
    token = params['hub.verify_token']

    if mode != 'subscribe' || token != 'STRAVA'
      render status: 400, text: nil
    else
      render status: 200, text: challenge
      # render status: 200, json: { "hub.challenge" => challenge }
    end
  end

  def post

  end
end
