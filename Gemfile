source 'https://rubygems.org'

ruby '2.2.2'
gem 'rails', '4.2.3'  # for edge Rails instead: gem 'rails', github: 'rails/rails'

gem 'pg', '~> 0.18.3'         # use postgresql as the database for Active Record
gem 'bcrypt', '~> 3.1.7'      # use bcrypt for encryption (passwords, etc.)
gem 'jbuilder', '~> 2.3.2'    # use jbuilder for building json representations

# in case we do use any rails ui elements
gem 'sass-rails', '~> 5.0'          # use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3.5.1'  # use bootstrap for a css framework
gem 'haml-rails', '~> 0.9.0'        # use haml as the templating engine
gem 'uglifier', '>= 1.3.0'          # use uglifier for compressing JavaScript assets
gem 'jquery-rails', '~> 4.0.5'      # use jquery as the JS framework

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby    # TODO: figure out if this is needed...
# gem 'turbolinks'                  # use turbolinks to follow links faster... (can mess up rails JS)

group :development do
  gem 'pry-rails', '~> 0.3.2'            # for better console
  gem 'better_errors', '~> 2.1.1'        # for better error messages
  gem 'binding_of_caller', '~> 0.7.2'    # for helping better_errors generate better stack traces
  gem 'meta_request', '~> 0.3.4'         # for rails tab in chrome
end

group :development, :test do
  gem 'rspec-rails', '~> 3.3.3'                   # use rspec for testing
  gem 'factory_girl_rails', '~> 4.5.0'            # use factory girl for factories
  gem 'faker', '~> 1.5.0'                         # use faker for generating fake data
  gem 'guard-rails', '~> 0.7.2', require: false   # use guard for automated testing
  gem 'guard-rspec', '~> 4.6.4', require: false   # use guard for automated testing
  gem 'spring', '~> 1.4.0'                        # keep the application running in the background.
  gem 'spring-commands-rspec', '~> 1.0.4'         # need this for guard/spring

  gem 'rb-fsevent', '~> 0.9.6' if `uname` =~ /Darwin/ # for osx

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 6.0.2'                        # use byebug for debugger

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.2.1'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.1'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'    # added this for heroku, not sure what it does
end

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
