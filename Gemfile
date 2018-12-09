# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.1'

# Use postgresql as the database for Active Record
gem 'pg', '1.1.3'

# Use Puma as the app server
gem 'puma', '3.12'

# Authentication
gem 'devise_token_auth', '1.0'

# Countries Information
gem 'countries', '2.1.4', require: 'countries/global'

# Active record object serializer
gem 'fast_jsonapi', '1.4'

# GUID generation
gem 'uuid', '2.3.9'

# File uploading
gem 'carrierwave', '1.2.3'
gem 'fog-aws', '3.3'

# Use ActiveStorage variant
gem 'mini_magick', '4.9.2'

# Transcodes videos
gem 'streamio-ffmpeg', '3.0.2'

# Backgroud worker
gem 'sidekiq', '5.2.3'

# ActiveRecord model to be organized in a tree structure
gem 'ancestry', '3.0.5'

# Activity tracking for ActiveRecord
gem 'public_activity', '1.6.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
gem 'rack-cors', '1.0.2'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'faker', '~> 1.9', '>= 1.9.1'
  gem 'shoulda', '~> 3.6'
end

group :development, :test do
  # Use Capistrano for deployment
  # gem 'capistrano-rails', group: :development

  # Call 'binding.pry' anywhere in the code to stop
  # execution and get a debugger console
  gem 'pry', '~> 0.11.3'

  # Access envirment veriable
  gem 'dotenv-rails', '~> 2.5'

  # RSpec (unit tests, some integration tests)
  gem 'rspec-rails', '~> 3.8'

  # Fixtures replacement
  gem 'factory_bot_rails', '~> 4.11'

  # Prints Ruby objects in full color exposing their internal structure
  gem 'awesome_print', '~> 1.8'

  # Ruby static code analyzer and code formatter
  gem 'rubocop', '~> 0.59.2', require: false

  # Help to kill N+1 queries and unused eager loading
  gem 'bullet', '~> 5.7', '>= 5.7.6'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
