web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 3
delayed_job: bundle exec rake jobs:work