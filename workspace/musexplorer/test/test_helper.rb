ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/around/unit'
require 'ffaker'
require 'simplecov'
require 'capybara/dsl'
require 'capybara/rails'
require 'database_cleaner'
Minitest::Reporters.use!
DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with :truncation
SimpleCov.start

class ActiveSupport::TestCase
	include FactoryGirl::Syntax::Methods
	include Capybara::DSL

	def setup
		DatabaseCleaner.start
	end
	def teardown
		DatabaseCleaner.clean
	end
  # Add more helper methods to be used by all tests here...
end
