require 'database_cleaner'

RSpec.configure do |config|
  # NOTE: make sure the following setting is set to false in the rails_helper
  # in order for the DatabaseCleaner settings to take effect.
  # config.use_transactional_fixtures = false

  # add to keep_tables the names of any tables that should not get wiped out when
  # cleaning db for tests
  keep_tables = %w[]

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, except: keep_tables, pre_count: true)

    begin
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with(:truncation, except: keep_tables, pre_count: true)
    end
  end

  config.before(:each, :js => true) do
    puts "this should only be for JS tests"
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
