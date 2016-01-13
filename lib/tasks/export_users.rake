require 'user_export'

namespace :export do
  desc "Exports current live users"
  task :users  => :environment do
    url = UserExport.perform
    puts "User list uploaded to #{url}"
  end
end
