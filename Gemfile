source 'https://rubygems.org'
ruby '2.2.3'

gem 'dotenv-rails',            :groups => [:development, :test]
gem 'rails',                   '4.2.2'
gem 'bcrypt',                  '3.1.7'
gem 'faker',                   '1.4.2'
gem 'carrierwave',             '0.10.0'
gem 'mini_magick',             '3.8.0'
gem 'fog'#,                     '1.3.1'
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass',          '3.2.0.0'
gem 'sass-rails',              '5.0.2'
gem 'uglifier',                '2.5.3'
gem 'coffee-rails',            '4.1.0'
gem 'jquery-rails',            '4.0.3'
gem 'jquery-ui-rails'
gem 'turbolinks',              '2.3.0'
gem 'jbuilder',                '2.2.3'
gem 'sdoc',                    '0.4.0', group: :doc
gem 'responders',              '2.0.0' 
gem 'cocoon'

# For SMS framework
gem 'twilio-ruby' # SMS
gem 'delayed_job_active_record' # Cron SMS jobs
gem 'delayed_job_recurring'
gem 'daemons' # Required for Cron jobs
gem 'phony_rails' # Phone normalization
gem 'interactor-rails', "~> 2.0"  # Get out of bloated models!
gem 'protected_attributes'  # Allows use of attr_accessible in Rails 4
gem 'figaro' # Secrets
gem 'dotiw' # More precise distance_of_time_in_words
gem 'best_in_place', github: 'bernat/best_in_place' # Inline edits of DB item
gem 'shoulda-matchers'  # Rspec validation testing library

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.4.0'
  gem 'timecop'

  # Testing / Troubleshooting tools
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails-erd'
  gem 'pry-byebug'
  # Rspec 
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails', '~> 4.4.1'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
  # Rspec
  gem 'capybara',           '~> 2.4.3'
  gem 'database_cleaner',   '~> 1.3.0'
  gem 'launchy',            '~> 2.4.2'
  gem 'selenium-webdriver', '~> 2.43.0'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '2.11.1'
  gem 'dynopoker' # pokes dyno every 30 minutes to prevent slow Heroku hosting
end
