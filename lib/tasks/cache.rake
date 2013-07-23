# Allow the cache to be cleared by rake task
namespace :cache do
  desc "Clears the application cache"
  task :clear  => :environment do
    if Rails.cache.is_a? ActiveSupport::Cache::MemoryStore
      puts 'Unable to clear cache, using :memory_store so different process from rake (you should try restarting the app server)'
    else
      Rails.cache.clear
    end
  end  
end
