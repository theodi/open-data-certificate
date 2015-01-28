source 'https://rubygems.org'

gem 'rails', '~> 3.2.21'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem "mongoid", "~> 3.0.0"
# gem 'bson_ext'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'haml'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'less-rails'
  gem 'less-rails-bootstrap', '~> 2.3.3'
  gem 'twitter-bootstrap-rails-confirm'

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem "factory_girl_rails", "~> 4.0"
  gem 'sqlite3'
  gem 'coveralls'
  gem 'shoulda'
  gem 'mocha', require: false
  gem 'test-unit'
  gem 'pry'
  gem 'csvlint', github: 'theodi/csvlint.rb'
  gem 'vcr'
  gem 'webmock'
  gem 'spork-rails'
  gem 'spork-testunit'
  gem 'shoulda-context'
  gem 'timecop'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end

group :development do
  gem 'guard', '~> 1.8.3'
  gem 'guard-test'
  # gem 'spring', github: 'jonleighton/spring'
  gem 'terminal-notifier-guard'
  gem 'ruby-prof'
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'rubyXL'
end

group :production do
  gem 'foreman'
  gem 'mysql2'
  gem 'airbrake'
  gem 'memcache-client'
  gem 'logstash-event'
  gem 'lograge'
end

gem 'jquery-rails'

#To serve static content / styleguide
gem 'high_voltage'

# states of the questionnaires
gem 'aasm'

# authorization
gem 'cancan'

# pagination
gem 'kaminari'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'
gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "ransack"
gem 'surveyor'
gem 'redcarpet'
gem "devise", "3.0.3"
gem 'dotenv-rails'
gem 'httparty'
gem 'data_kitten'
gem 'delayed_job_active_record'
gem 'linkeddata'
gem 'rack-linkeddata'
gem 'jbuilder'
gem 'odlifier', '0.1.1'
gem 'rack-cors'
gem 'alternate_rails', :github => 'theodi/alternate-rails'
gem 'fog'
gem 'juvia_rails', github: 'theodi/juvia_rails'
gem 'domainatrix'
# newrelic appears to be adding significant performance problems
#gem 'newrelic_rpm'
gem 'google_drive'
gem 'pry-remote'
gem 'memoist'
gem 'validate_url'
