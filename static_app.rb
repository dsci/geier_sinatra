# => main sinatra file for skaterhockey-leipzig.de prototype
# @author Daniel Schmidt (dsci@skaterhockey-leipzig.de)
#require "rubygems"
#require "bundler/setup"
require "setup_load_paths"
require "RedCloth"
require "sinatra"
require "weather"
require "bishl"
require "sqlite3" unless production?
require 'sinatra/activerecord'
require "gmail"
# setup bundler dependencies
begin
  # Set up load paths for all bundled gems
  #ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

# include ActiveRecord models, Sinatra helpers, sinatra db config and so on.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'lib','**','*.rb'))].each {|f| require f}


#include textile reader
include FileHelper

#include BISHL helper stuff
include Bishl::HTMLHelper

PAGE_TITLE = "{prefix} - skaterhockey-leipzig.de"

#not_found do
#  "Your page cannot be found"
#end

get "/" do
  #@env = development?
  #@content = read_file(content_file_path("start.textile")).to_textile
  @news = News.tops
  page_title("Start")
  erb :index
end

get "/news/:id" do
  @news = News.find(params[:id])
  @content = News.find(params[:id]).text
  page_title(@news.title)
  erb :news
end

get "/mitmachen" do
  @content = read_file(content_file_path("info.textile")).to_textile
  page_title("Mitmachen")
  erb :static_page
end

get "/mannschaft" do
  @team = read_file(content_file_path("team.textile")).to_textile
  page_title("Team")
  erb :team
  # get all players

  # get all officials

end

get "/spieler/:nummer/:name/:vorname" do
  
end

get "/halle" do
  # insert google maps for taucha and park5.1
  page_title("Spielstätten")
  erb :static_page
end

get "/spielplan/:year" do
  page_title("Spielplan")
  @year = params[:year]
  @games = BISHL.schedule({:season => @year,:cs => "LLA", :team => 74})
  erb :schedule
end

get "/impressum" do
  page_title("Impressum")
  @content = read_file(content_file_path("impressum.textile")).to_textile
  erb :static_page
end

get "/fetch/data" do
  # fetch emails here and insert objects into db.
  MailOperator::import_news
end

get "/cleanup" do
  MailOperator::delete_news
end

get "/flyer" do
  
  @flyers = []
  @base_uri = "/flyer"
  excludes = [".", "..", ".DS_Store"]
  Dir.foreach(File.join(File.dirname(__FILE__), "public", "flyer")).each do |flyer|
    unless excludes.include?(flyer)
      @flyers << flyer
    end
  end
  erb :flyer, :layout => false
end

get "/archiv" do
  @news = News.all-News.tops
  erb :news_index
end
