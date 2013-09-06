require File.join(Rails.root, 'lib/tasks/data_dump')

namespace :dump do
  
  namespace :certificates do
    
    desc "Dump data for certificates all current certificates"
    task :all_current => :environment do        
      a = []
        
      certs = Certificate.where(:published => true)
      certs.each do |cert|
        a << build_item(cert)
      end
    
      json = "{#{a.join(',')}}"
    
      upload(json)
    end
  
    desc "Get the latest data and add it to the dump"
    task :latest => :environment do
      new = 0
      updated = 0
      
      dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
      file = dir.files.head "certificates.json"
      
      certs = Certificate.where(:published => true).
                where("updated_at > ?", file.last_modified)
      
      if certs.count > 0
        json = JSON.parse(dir.files.get("certificates.json").body)
        # Loop through results
        certs.each do |cert|
          url = av.dataset_certificate_url(cert.dataset, cert)
          if json[url].nil?
            # If certificate doesn't exist, add it
            json << JSON.parse("{"+ build_item(cert) +"}")
            new += 1
          else
            # If not, update what's already there
            json[url] = JSON.parse("{"+ build_item(cert) +"}")
            updated += 1
          end
        end
        upload(json.to_s)
        puts "#{new} certificates added"
        puts "#{updated} certificates updated"
      end
    end
  
  end
end