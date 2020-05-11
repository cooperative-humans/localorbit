source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.6'
gem 'bundler', '1.17.3'

# This needs to load before other gems
gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'rails', '~> 4.2.11.1'

gem 'pg', '0.21.0'
gem 'sqlite3', '~> 1.3.6'

gem 'rails_12factor', group: :production
gem 'roxml', :git => 'https://github.com/Empact/roxml.git', :tag => 'v4.0.0'

# Assets
gem 'sass-rails',   '~> 4.0.0'
gem 'uglifier',     '~> 2.7.2'
gem 'coffee-rails', '~> 4.0.0'

# The jQuery update is doing something weird
# with data confirms and poltergeist
gem 'jquery-rails', '~> 3.1.3'
gem 'jquery-ui-rails', '5.0.0'
gem 'accountingjs-rails', '0.0.4'
gem 'compass-rails', '2.0.0'
gem 'underscore-rails', '1.7.0'
gem 'wysihtml5-rails', '0.0.4'

gem 'active_model_serializers', '0.9.0'
gem 'active_record_query_trace', '1.5.4'
gem 'active_record_union', '1.0.1'
gem 'audited-activerecord', '4.0.0'
gem 'awesome_nested_set', '3.0.1'
# gem 'bootsnap', require: false # TODO: Remove this when we upgrade to rails 5.2
gem 'color', '1.7.1'
gem 'countries', '0.9.3'
gem 'csv_builder', '2.1.1'
gem 'delayed_job_active_record', '4.1.3'
gem 'devise', '~> 4.5.0'
gem 'devise_invitable', '1.7.4'
gem 'devise_masquerade', '0.6.4'
gem 'dragonfly-s3_data_store', '1.0.4'
gem 'draper', '1.3.1'
gem 'groupdate', :git => 'https://github.com/trestrantham/groupdate.git', :branch => 'custom-calculations' # Waiting on https://github.com/ankane/groupdate/pull/53
gem 'interactor-rails', '2.0.1'
# gem 'interactor', '< 3.0' # We are not ready for 3 yet
gem 'jbuilder', '2.1.3'
gem 'jwt', '1.5.6'
gem 'kaminari', '0.16.1'
gem 'mini_racer'
gem 'pdfkit', '0.8.2'
gem 'periscope-activerecord', '2.1.0'
gem 'pg_search', '0.7.8'
gem 'rack-canonical-host', '0.1.0'
gem 'ransack', '1.6.4'
gem 'recaptcha', '5.1.1'
# RAILS42 TODO: gem 'responders', '~> 2.0'
gem 'simpleidn', '0.1.0'
# gem 'skylight'
gem 'stripe', '5.14.0'
gem 'stripe_event', '2.3.0'
gem 'font-awesome-rails', '4.4.0.0'
gem 'wysiwyg-rails', '1.2.8'
gem 'kiba', '0.6.1' # ETL Tool

gem "browserify-rails", '0.9.3' # Support
gem "react-rails", '1.4.2'

gem 'migration_data', '0.6.0'

gem "pundit", '1.1.0'

gem 'httparty', '0.13.7'
gem 'omniauth-stripe-connect', '2.10.1'

gem 's3_direct_upload', :git => 'https://github.com/waynehoover/s3_direct_upload.git', :ref => '6972033d'

gem 'constructor', '2.0.0'
gem 'tabulator', :git => 'https://github.com/dcrosby42/tabulator.git', :ref => 'aa3d14ea73'
gem 'rschema', :git => 'https://github.com/tomdalling/rschema.git', :tag => 'v2.4.0'

gem 'turbolinks', '2.5.3'

install_if -> { ENV['ON_HEROKU'] != 'true' } do
  # Maybe try 0.12.5.4 if run into issues
  gem 'wkhtmltopdf-binary', '0.12.5.4'
end
# install_if -> { ENV['ON_HEROKU'] == 'true' } do
#   gem 'wkhtmltopdf-heroku'
#   gem 'rails_12factor'
#   gem 'platform-api'
# end

# Product import/export
gem 'rubyXL', '3.3.10', require: false # XLSX
gem 'spreadsheet', '1.0.3', require: false # XLS
gem 'slop', '~> 3.0', require: false # option parsing
gem 'dedent', '1.0.1', require: false
gem 'activerecord-import', require: false
gem 'grape' # API v2
gem 'grape-active_model_serializers' # API v2
gem 'rack-cors', :require => 'rack/cors' # API v2
gem 'grape-swagger' # API V2, documentation
gem 'puma' # was 3.12.4

gem 'rollbar' # was 2.23.2

gem "attr_encrypted", '~> 3.0.0'

group :doc do
  gem 'sdoc', '0.4.1', require: false
end

group :development do
  gem 'aws_config'
  gem 'bullet'
  # gem 'capistrano'
  # gem 'capistrano-aws', require: false
  # gem 'capistrano-bundler'
  # gem 'capistrano-git_deploy', github: 'thermistor/capistrano-git_deploy', require: false
  # gem 'capistrano-passenger'
  # gem 'capistrano-rails'
  gem 'ultrahook'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rubocop', require: false
  gem 'quiet_assets'
  gem 'aws-sdk'
  gem 'railroady'
  gem 'rails_view_annotator'
  gem 'rubycritic', require: false
  gem 'mailcatcher'

  # profiling, see https://github.com/MiniProfiler/rack-mini-profiler#installation
  gem 'rack-mini-profiler'
  gem 'memory_profiler'
  gem 'flamegraph'
  gem 'stackprof'
end

group :development, :test, :build do
  gem 'factory_bot_rails', '4.8.2'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec_junit_formatter', :git => 'https://github.com/sj26/rspec_junit_formatter.git'
  gem 'rspec-collection_matchers'
  gem 'pry-rails'
  gem 'pry-remote'
  # gem 'byebug'
  # gem 'pry-byebug'
  gem 'launchy'
  gem 'awesome_print'
  gem 'konacha'
  gem 'konacha-chai-matchers'
  gem 'webmock'
  gem 'capybara-slow_finder_errors'
  gem 'capybara'
  gem 'selenium-webdriver', '3.141.0' # Can remove once we're able to upgrade capybara https://stackoverflow.com/a/55816611/444921
  gem 'webdrivers'
end

group :test do
  gem 'simplecov', require: false
  gem 'domino', '< 0.8.0' # v0.8.0 breaks child classes in PackList. Need to dig in more.
  gem 'email_spec'
  gem 'database_cleaner'
  gem 'guard-rspec', require: false
  gem 'guard-konacha-rails'
  gem 'timecop'
  gem 'vcr'
  gem 'fire_poll', '1.2.0'
  gem 'capybara-screenshot'
  gem 'stripe-ruby-mock', '~> 2.5.8', :require => 'stripe_mock'
end

group :production, :staging do
  gem 'newrelic_rpm'
  gem 'newrelic-dragonfly'
  #gem 'passenger'
  # gem 'rack-cache', require: 'rack/cache'
end
