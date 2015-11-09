class WebhooksController < ApplicationController
  def get
    challenge = params['hub.challenge']
    token = params['verify_token']

    if token == '0809756ca4e9bac126e09e3613dfe665'
      render status: 200, text: challenge
    else
      render status: 400
    end
  end

  def post

  end
end
