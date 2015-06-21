class GraphsController < ApplicationController
  def rickshaw
    @start_date = Time.new(2015, 5, 1)
    @end_date = Time.new(2015, 10, 1)

    @remaining = @end_date - Time.now
    @elapsed = Time.now - @start_date
    @duration = @end_date - @start_date

    @users = User.ranked

    @colors = [
      'rgb(66, 133, 244)',
      'rgb(219, 68, 55)',
      'rgb(244, 180, 0)',
      'rgb(15, 157, 88)',
      'rgb(171, 71, 188)',
      'rgb(0, 172, 193)',
      'rgb(255, 112, 67)',
      'rgb(158, 157, 36)',
      'rgb(92, 107, 192)',
      'rgb(240, 98, 146)',
      'rgb(0, 121, 107)',
      'rgb(194, 24, 91)',
      'rgb(255, 157, 0)',
      'rgb(157, 157, 157)',
      'rgb(0, 90, 120)',
      'rgb(0, 157, 157)',
      'rgb(255, 157, 0)',
    ]
  end
end
