class WebhooksController < ApplicationController
  def get
    mode = params['hub.mode']
    challenge = params['hub.challenge']
    token = params['hub.verify_token']

    if mode != 'subscribe' || token != '0809756ca4e9bac126e09e3613dfe665'
      render status: 400, text: nil
    else
      render status: 200, text: challenge
    end
  end

  def post

  end
end
