RSpec.configure do |config|

  # add to keep_tables the names of any tables that should not get wiped out when
  # cleaning db for tests
  keep_tables = %w[]
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with(:truncation, except: keep_tables)
    end
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
