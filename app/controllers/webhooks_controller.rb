class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get
    mode = params['hub.mode']
    challenge = params['hub.challenge']
    token = params['hub.verify_token']

    if mode != 'subscribe' || token != 'STRAVA'
      render status: 400, text: nil
    else
      # render status: 200, text: challenge
      render status: 200, json: { "hub.challenge" => challenge }
    end
  end

  def post
    # {
    #   "subscription_id": "1",
    #   "owner_id": 13408,
    #   "object_id": 12312312312,
    #   "object_type": "activity",
    #   "aspect_type": "create",
    #   "event_time": 1297286541
    # }

    update = JSON.parse(request.body.read)

    if update['object_type'] = 'activity' && update['aspect_type'] == 'create'
      activity = StravaClient.retrieve_an_activity(update['object_id'])
      Notifier.post_activity(activity)

      render status: 200, text: nil
    else
      render status: 403, text: '403'
    end
  end
end
