require 'rubygems'
#require 'bundler'

#Bundler.require

require 'static_app'

root_dir = File.dirname(__FILE__)
 
set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    File.join(root_dir, 'static_app.rb')
disable :run
 


run Sinatra::Application