require File.join(File.dirname(__FILE__), '..', '/static_app')

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack/test'
require 'rspec'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

#Dir[File.expand_path(File.join(File.dirname(__FILE__),"..",'/lib','**','*.rb'))].each {|f| require f}
#require File.join(File.dirname(__FILE__), "..", "/static_app")
#require File.join(File.dirname(__FILE__), "..", "/lib", "models", "news")
#require File.join(File.dirname(__FILE__), "..", "/lib", "mail_operator")

RSpec.configure do |c|
  
  c.before(:all) do
    db_config = {:adapter => "sqlite3",
                 :database  => "sinatra-test.db"
                 }
    ActiveRecord::Base.establish_connection(db_config)
     
  end
  
end

def fetch_mail_adress
  "web@skaterhockey-leipzig.de"
end


