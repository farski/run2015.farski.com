class StravaAthlete
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def label
    "#{data['firstname'].capitalize} #{data['lastname'][0].capitalize}"
  end
end
