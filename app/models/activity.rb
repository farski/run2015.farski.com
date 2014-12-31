class Activity < ActiveRecord::Base
  belongs_to :user

  scope :runs, -> { where(strava_type: 'Run') }
  scope :c2014, -> { where(['start_date >= ?', Time.new(2014, 5, 5)]).where(['start_date <= ?', Time.new(2014, 9, 12)]) }
  scope :p2015, -> { where(['start_date >= ?', Time.new(2014, 12, 1)]).where(['start_date < ?', Time.new(2015, 5, 1)]) }
  scope :c2015, -> { where(['start_date >= ?', Time.new(2015, 5, 1)]).where(['start_date < ?', Time.new(2015, 10, 1)]) }
end
