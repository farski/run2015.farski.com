require 'singleton'

class StravaClient
  include Singleton

  attr_accessor :client

  def self.retrieve_an_activity(*args)
    StravaActivity.new(StravaClient.instance.client.retrieve_an_activity(*args))
  end

  def initialize
    token = ENV['STRAVA_ACCESS_TOKEN']
    @client = ::Strava::Api::V3::Client.new(access_token: token)
  end
end
