namespace :strava do
  desc "Check for new activities from all registered users"
  task :update => :environment do
    activities = Import.import
    puts "#{activities.count} new activities found"
  end

  task :notify => :environment do
    Relay.new.run
  end
end
