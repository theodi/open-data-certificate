gem 'rails', '~> 3.2.21'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem "mongoid", "~> 3.0.0"
# gem 'bson_ext'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'haml', '>= 3.1.3'

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
  gem 'csvlint', github: 'theodi/csvlint.rb'
  gem 'vcr'
  gem 'webmock'
  gem 'shoulda-context'
  gem 'timecop'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'

  # From surveyor
  gem 'json_spec', '~> 1.0.3'
end

group :development do
  gem 'guard', '~> 1.8.3'
  gem 'guard-test'
  # gem 'spring', github: 'jonleighton/spring'
  gem 'terminal-notifier-guard'
  gem 'ruby-prof'
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'rubyXL'
  gem 'parallel_tests'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'rspec-rails', '~> 2.14.2'
end

group :production do
  gem 'foreman'
  gem 'mysql2'
  gem 'airbrake'
  gem 'delayed-plugins-airbrake'
  gem 'logstash-event'
  gem 'lograge'
end

group :surveyor do
  gem 'fastercsv', '~> 1.5.4'
  gem 'formtastic', '~> 2.1.0'
  gem 'uuidtools', '~> 2.1'
  gem 'mustache', '0.99.4'
  gem 'rabl', '~>0.6.13'
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
gem 'surveyor', path: 'vendor/gems/surveyor-1.4.0'
gem 'redcarpet'
gem "devise", "3.0.3"
gem 'dotenv-rails'
gem 'httparty'
gem 'data_kitten', github: 'theodi/data_kitten'
gem 'delayed_job_active_record'
gem 'linkeddata'
gem 'rack-linkeddata'
gem 'jbuilder'
gem 'rack-cors', require: 'rack/cors'
gem 'alternate_rails', :github => 'theodi/alternate-rails'
gem 'fog'
gem 'juvia_rails', github: 'theodi/juvia_rails'
gem 'domainatrix'
# newrelic appears to be adding significant performance problems
#gem 'newrelic_rpm'
gem 'google_drive'
gem 'memoist'
gem 'validate_url'
gem 'sidekiq'
gem 'sinatra', :require => nil
gem 'sidekiq-failures'
gem 'rails-i18n', '~> 3.0.0'
