source "https://rubygems.org"

ruby "2.2.7"

gem 'rails', '~> 3.2'
gem 'rake', '< 12.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem "mongoid", "~> 3.0.0"
# gem 'bson_ext'

gem 'mysql2', '~> 0.3.10' # limit to this version for Rails 3.2

# For some reason this is needed in production for consoles
gem 'test-unit'


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

  gem 'uglifier', '>= 3.2.0'
end

group :test, :development do
  gem "factory_girl_rails", "~> 4.9"
  gem 'sqlite3'
  gem 'coveralls'
  gem 'shoulda'
  gem 'mocha', require: false
  gem 'csvlint'
  gem 'vcr'
  gem 'webmock'
  gem 'shoulda-context'
  gem 'timecop'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'

  # From surveyor
  gem 'json_spec', '~> 1.1.5'

  gem 'guard', '~> 2.14.1'
  gem 'guard-test'
  # gem 'spring', git: 'https://github.com/jonleighton/spring.git'
  gem 'terminal-notifier-guard'
  gem 'ruby-prof'
  gem 'rails-footnotes', '>= 4.1.8'
  gem 'parallel_tests'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'

  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'rspec-rails', '~> 2.14.2'
end

group :production do
  gem 'foreman'
  gem 'airbrake'
  gem 'delayed-plugins-airbrake'
  gem 'logstash-event'
  gem 'lograge'
  gem 'rails_12factor'
end

gem 'uuidtools', '~> 2.1'
gem 'fastercsv', '~> 1.5.4'
gem 'formtastic', '~> 2.1.0'
gem 'mustache', '1.0.5'
gem 'rabl', '~>0.13.1'

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

# web server
gem 'puma'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "ransack"
gem 'surveyor', git: 'https://github.com/theodi/odc-surveyor.git'
gem 'redcarpet'
gem "devise", "3.0.3"
gem 'dotenv-rails'
gem 'httparty'
gem 'data_kitten', git: 'https://github.com/theodi/data_kitten.git', ref: '0597206bc522a03110f8fe89be111589dcecf6b6'
gem 'delayed_job_active_record'
gem 'linkeddata'
gem 'rack-linkeddata'
gem 'jbuilder'
gem 'rack-cors', require: 'rack/cors'
gem 'alternate_rails', git: 'https://github.com/theodi/alternate-rails.git', ref: "188889d66c5df1d7d13f7c6e53e8088e3503dea1"
gem 'fog'
gem 'juvia_rails', git: 'https://github.com/theodi/juvia_rails.git', ref: '94f982aa8188a18bc0f37c16218c85e890d25294'
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
gem 'eventmachine', '~> 1.2.5'
gem 'daemons'
