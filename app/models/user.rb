class User < ActiveRecord::Base
  has_many :activities

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

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
    @ranked ||= User.select('"users".*, SUM("activities"."distance") AS sum_activities_distance').joins(:activities).group('"users"."id"').where(['"activities"."start_date_local" >= ?', Time.new(2015, 5, 1)]).where(['"activities"."start_date_local" < ?', Time.new(2015, 10, 1)]).where(%q|"activities"."strava_type" LIKE 'Run'|).order("sum_activities_distance DESC")
  end

  def total
    @total ||= activities.c2015.sum('distance')
  end

  def average
    start_date = Time.new(2015, 5, 1)
    elapsed = Time.now - start_date

    (total / elapsed)
  end

  def projection
    start_date = Time.new(2015, 5, 1)
    end_date = Time.new(2015, 10, 1)
    duration = end_date - start_date

    (average * duration)
  end

  def label
    "#{forename.capitalize} #{surname[0].capitalize}."
  end
end
