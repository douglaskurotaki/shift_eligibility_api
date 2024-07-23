# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
# Swagger generators for RSpec
gem 'rswag-api'
# Swagger UI engine for API documentation
gem 'rswag-ui'

group :development, :test do
  # Maintains clean DB state for testing
  gem 'database_cleaner-active_record'
  # Debugging tool for Ruby
  gem 'debug', platforms: %i[mri windows]
  # Simplifies test object creation
  gem 'factory_bot_rails'
  # Generates fake data
  gem 'faker'
  # Combines pry with byebug for debugging
  gem 'pry-byebug'
  # Testing framework for Rails
  gem 'rspec-rails'
  # Swagger-based DSL for testing API operations
  gem 'rswag-specs'
  # Provides RSpec- and Minitest-compatible one-liners to test common Rails functionalities
  gem 'shoulda-matchers'
  # Code coverage analysis tool for Ruby
  gem 'simplecov'
  # JSON formatter for SimpleCov output
  gem 'simplecov_json_formatter'
end
