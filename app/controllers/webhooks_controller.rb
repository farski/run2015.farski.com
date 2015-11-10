class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def subscriptions
    uri = URI.parse("https://api.strava.com/api/v3/push_subscriptions?client_id=#{ENV['STRAVA_CLIENT_ID']}&client_secret=#{ENV['STRAVA_CLINET_SECRET']}")
    response = Net::HTTP.get_response(uri)
    @subscriptions = JSON.parse(response.body)
  end

  def get
    mode = params['hub.mode']
    challenge = params['hub.challenge']
    token = params['hub.verify_token']

    if mode != 'subscribe' || token != ENV['STRAVA_VERIFY_TOKEN']
      render status: 400, text: nil
    else
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
