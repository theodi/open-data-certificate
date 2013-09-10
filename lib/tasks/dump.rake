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
end