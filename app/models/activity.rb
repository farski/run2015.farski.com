class Activity < ActiveRecord::Base
  belongs_to :user

  scope :runs, -> { where(strava_type: 'Run') }
end
