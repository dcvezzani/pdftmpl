# DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  # config.use_transactional_fixtures = false
  # config.before :each do
  #   DatabaseCleaner.start
  # end
  # config.after :each do
  #   DatabaseCleaner.clean
  # end

  config.use_transactional_fixtures = true
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.clean_with :transaction
  end  
  config.around(:each, type: :feature, js: true) do |ex|
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    self.use_transactional_fixtures = false
    ex.run
    self.use_transactional_fixtures = true
    DatabaseCleaner.clean
  end  
end
