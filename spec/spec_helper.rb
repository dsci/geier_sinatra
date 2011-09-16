require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'database_cleaner'
require 'yajl'

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '/lib/c_cut.rb')

# set test environment
set :environment, ENV['RACK_ENV']
set :run, false
set :raise_errors, true
set :logging, true

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

#Dir[File.expand_path(File.join(File.dirname(__FILE__),"..",'/lib','**','*.rb'))].each {|f| require f}
#require File.join(File.dirname(__FILE__), "..", "/static_app")
#require File.join(File.dirname(__FILE__), "..", "/lib", "models", "news")
#require File.join(File.dirname(__FILE__), "..", "/lib", "mail_operator")

RSpec.configure do |config|
  
  config.include LastResponseSamples
  
  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
  
end

def fetch_mail_adress
  "web@skaterhockey-leipzig.de"
end


