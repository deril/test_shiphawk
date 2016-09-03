require 'rack/test'
require 'rspec'
require 'rspec/json_expectations'
require 'rspec/its'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  c.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end
