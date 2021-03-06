class User < ActiveRecord::Base
  has_many :activities

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  default_scope { where(enabled: true) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.find_for_oauth(auth, signed_in_resource = nil)
    user = find_by(uid: auth.uid, provider: auth.provider)

    if user.nil?
      user = User.new(
        uid: auth.uid,
        provider: auth.provider,
        forename: auth.info.first_name,
        surname: auth.info.last_name,
        token: auth.credentials.token,
        password: Devise.friendly_token[0,20],
        email: auth.info.email
      )
      user.save!
    end

    user
  end

  def self.ranked
    User.select('"users".*, SUM("activities"."distance") AS sum_activities_distance').joins(:activities).group('"users"."id"').where(['"activities"."strava_type" = ? AND "activities"."start_date_local" >= ?', 'Run', Time.new(2015, 5, 1)]).where(['"activities"."start_date_local" < ?', Time.new(2015, 10, 1)]).where(%q|"activities"."strava_type" LIKE 'Run'|).order("sum_activities_distance DESC")
  end

  def strava_client
    @client ||= ::Strava::Api::V3::Client.new(access_token: token)
  end

  def score(scope = :c2016)
    _runs = runs.try(scope).to_a
    _runs.reduce(0) do |total, run|
      [total, run.score].reduce(:+)
    end
  end

  def runs
    activities.runs
  end

  def mruns
    @mruns ||= activities.runs.c2016
  end

  def ranking
    (User.ranked.map(&:id).index(id) + 1)
  end

  def sparklist
    list = []
    runs.c2016.order('start_date ASC').each do |run|
      # list << ((run.distance / 1000) + list.last).to_i
      list << (run.distance / 1000).to_i
      # list << (run.distance / run.moving_time).to_f
    end
    list
  end

  def total
    activities.c2016.sum('distance')
  end

  def total_time
    activities.c2016.sum('moving_time')
  end

  def fortnight_total
    activities.c2016.fortnight.sum('distance')
  end

  def average
    start_date = Time.new(2016, 5, 1)
    elapsed = Time.now - start_date

    (score / elapsed)
  end

  def average_speed
    # In m/s
    total / total_time
  end

  def fortnight_average
    start_date = 14.days.ago
    elapsed = Time.now - start_date

    (fortnight_total / elapsed)
  end

  def projection
    start_date = Time.new(2016, 5, 1)
    end_date = Time.new(2016, 10, 1)
    duration = end_date - start_date

    (average * duration)
  end

  def fortnight_projection
    start_date = Time.now
    end_date = Time.new(2016, 10, 1)
    duration = end_date - start_date

    total + (fortnight_average * duration)
  end

  def label
    "#{forename.capitalize} #{surname[0].capitalize}."
  end
end
