#require 'rubygems'
#require 'bundler'

#Bundler.require

#require File.expand_path(File.join(File.dirname(__FILE__),'static_app.rb'))

#root_dir = File.dirname(__FILE__)
 
#set :root,        root_dir
#set :app_file,    File.join(root_dir, 'static_app.rb')
#disable :run
 


#run Sinatra::Application

# config.ru
require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'c_cut'))

#set :environment, ENV['RACK_ENV'].to_sym
run CCut::Application