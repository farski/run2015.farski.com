namespace :strava do
  # desc "Check for new activities from all registered users"
  # task :update => :environment do
  #   activities = Import.import
  #   puts "#{activities.count} new activities found"
  # end

  task :pull => :environment do
    Relay.new.run
  end
end
