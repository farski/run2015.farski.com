class StravaAthlete
  attr_reader :data

  def initialize(data)
    if data['resource_state'] == 1
      @data = StravaClient.instance.client.retrieve_another_athlete(data['id'])
    else
      @data = data
    end
  end

  def label
    "#{data['firstname'].capitalize} #{data['lastname'][0].capitalize}"
  end
end
