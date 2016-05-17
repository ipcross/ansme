require 'rails_helper'

Capybara::Webkit.configure do |config|
  config.allow_url("js.stripe.com")
end

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  # Capybara.default_max_wait_time = 5

  config.include AcceptanceMacros, type: :feature
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
