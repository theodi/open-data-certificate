source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem "mongoid", "~> 3.0.0"
# gem 'bson_ext'

gem 'surveyor'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'haml'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'less-rails'
  gem 'less-rails-bootstrap'#, :git => 'git://github.com/theodi/less-rails-bootstrap.git'

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem "factory_girl_rails", "~> 4.0"
  gem 'sqlite3'
  gem 'simplecov'
  gem 'shoulda'
  gem 'mocha', require: false
  gem 'test-unit'
end

group :development do
  gem 'guard'
  gem 'guard-test'
  gem 'ruby-prof'
end

group :production do
  gem 'foreman'
  gem 'mysql2'
  gem 'airbrake'
end

gem 'jquery-rails'

#To serve static content / styleguide
gem 'high_voltage'

# authorization
gem 'cancan'

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

gem 'surveyor'

gem "devise", ">= 2.2.3"

gem 'dotenv-rails'

gem 'google-analytics-rails'
