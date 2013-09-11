require File.join(Rails.root, 'lib/tasks/data_dump')

namespace :dump do
  
  namespace :certificates do
    
    desc "Dump data for certificates all current certificates"
    task :all_current => :environment do        
      DataDump.current_certificates
    end
  
    desc "Get the latest data and add it to the dump"
    task :latest => :environment do
      DataDump.latest_certificates
    end
  
  end
  
  namespace :stats do
    
    desc "Dump statistics"
    task :setup => :environment do
      DataDump.setup_stats
    end
    
    desc "Dump statistics for today"
    task :today => :environment do
      DataDump.latest_stats
    end
    
  end
end