# Application file for www.skaterhockey-leipzig.de
#
# @author Daniel Schmidt (dsci@skaterhockey-leipzig.de) 
require "rubygems"
require "bundler/setup"

libs = %w(weather bishl mongoid RedCloth sinatra/base json
          digest/sha1 rack-flash gmail yaml haml slim sinatra-authentication)

libs.each{|library| require library}

# set yaml engine only if used Ruby is 1.9
YAML::ENGINE.yamler= 'syck' if RUBY_VERSION.include?("1.9")

# setup bundler dependencies
begin
  # Set up load paths for all bundled gems
  #ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

# require 'config'
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'config', '*.rb'))].each{|config| require config}
# require 'models'
Dir[File.expand_path(File.join(File.dirname(__FILE__),'models','**','*.rb'))].each {|model| require model}
# require 'helpers
Dir[File.expand_path(File.join(File.dirname(__FILE__),'helpers','**','*.rb'))].each {|helper| require helper}

# add custom fields to MongoidUser
MongoidUser.class_eval do
  
  field :user_name, :type => String
  field :role_name, :type => String, :default => "user"
  
end

module CCut
  
  # The main application. Nothing more and nothing less.
  class Application < Sinatra::Base
    # mix knowledge of SinatraAuthentication into the app
    register Sinatra::SinatraAuthentication  
      
    use Rack::Session::Cookie, :secret => "Nearly all men can stand adversity, but if you want to test a man's character give him power."
    use Rack::Flash
    
    #include textile reader
    include FileHelper

    #include BISHL helper stuff, from gem 'bishl'
    include Bishl::HTMLHelper if defined?(Bishl)
    
    configure do
      set :environment, ENV['RACK_ENV']
      set :default_encoding, "utf-8"
      set :locales, File.join(File.dirname(__FILE__), 'i18n/de.yml')
      set :views, File.join(File.dirname(__FILE__), 'views')
      set :public, File.dirname(__FILE__) + '/public'
      set :show_exceptions, true if development?
      set :layout_engine, :erb
    end

    PAGE_TITLE = "{prefix} - skaterhockey-leipzig.de"
    
    
    helpers do

      def test_env?
        return ENV['RACK_ENV'].eql?("test")
      end

      def partial(template)
        erb template, :layout => false
      end

      def link_to(text,url)
        "<a href=/#{url.to_s}>#{text}</a>"
      end

      def current_page
        @current_page ||= request.path_info
      end

      def active_class(url)
        current_page.eql?("/#{url}") ? "active" : "not_active"
      end

      def weather
        WeatherHelper.weather_info
      end

      def disqus_excludables
        ["/halle", "/mannschaft", "/"]
      end

      def page_title(prefix)
        @page_title = PAGE_TITLE.gsub("{prefix}", prefix)
      end

      def textilize(s)
        s.to_textile
      end

      # slices a text!
      def s(text)
        text.slice(0..200).concat("...")
      end

      def opponent(game)
        return game.hometeam if game.awayteam_id == "74"
        return game.awayteam if game.hometeam_id == "74"
      end

      def home_css(game)
        game.hometeam_id == "74" ? "home" : ""
      end

      def result(game)
        #<%=game.goalshome%> : <%=game.goalsaway%>
        if game.goalshome.empty? and game.goalsaway.empty?
          ""
        else
          if game.hometeam_id == "74"
            "#{game.goalshome} : #{game.goalsaway}"
          else
            "#{game.goalsaway} : #{game.goalshome}"
          end
        end
      end

      def opponent_id(game)
        return game.hometeam_id if game.awayteam_id == "74"
        return game.awayteam_id if game.hometeam_id == "74"
      end

      def game_time(game)
        game.date.strftime('%d.%m.%Y %H:%M')
      end

      def type_of(game)
        if home_css(game) == "home"
          return "<strong>(Heim)</strong>"
        else
          return "<em>(Ausw&auml;rts)</em>"
        end
      end

      def next_game
        game = BISHL.next_game_for({:season => Time.now.year.to_s, :cs => "LLA",  :team => "74"})
        unless game.empty?
          <<-HTML
            <img src='#{BISHL.logo_for(:team => opponent_id(game.first))}' width="115" height="115" />
            <p id="opponent">#{opponent(game.first)}</p>
            <ul>
              <li>#{game_time(game.first)}</li>
              <li id="stadium">
                 #{type_of(game.first)}
              </li>
            <ul>
          HTML
        end
      end

      def last_game
        game = BISHL.last_game_for({:season => Time.now.year.to_s, :cs => "LLA", :team => "74"})
        if(game.first.hometeamid.eql?("74"))
          result_line = "#{game.first.goalshome}:#{game.first.goalsaway}"
        else
          result_line = "#{game.first.goalsaway}:#{game.first.goalshome}"
        end
        unless game.empty?
          <<-HTML
          <div id="last_game">
            <p id="last_opponent">vs .#{opponent(game.first)}, #{result_line}</p>
            <div></div>
          </div>
          HTML
        end

      end

    end
    
    get "/admin" do
      login_required
      slim :admin, :layout => :admin_layout
    end
    
    #################################################################
    # news section                                                  #
    #################################################################
    
    # Adds a news to the database.
    post "/news" do
      login_required unless test_env?
      content_type :json
      news = News.new(params[:news])
      result = {}
      if news.save
        result.merge!({:success => true, :news => [news.as_json]})
      else
        result.merge!({:success => false, :errors => news.errors})
      end
      result.to_json
    end
    
    # List all news that are stored in the database. 
    get "/news" do
      login_required
    end
    
    # Get a news by an id. Requires no logged in user. 
    get "/news/:id" do
      @news = News.find(params[:id])
      @content = News.find(params[:id]).text
      page_title(@news.title)
      erb :news
    end
    
    # Deletes a news given by an id from the database.
    delete "/news/:id" do
      result = {}
      login_required unless test_env?
      content_type :json
      begin
        @news = News.find(params[:id])
        if @news.destroy
          result.merge!({:success => true})
        end  
        result.to_json
      rescue
        {:success => false}.to_json
      end
    end
    
    # Updates a news given by an id. 
    put "/news/:id" do
      login_required unless test_env?
      content_type :json
      @news = News.find(params[:id])
      result = {}
      if @news.update_attributes(params[:news]) 
        result.merge!({:success => true,:news => [@news.as_json]})
      else
        result.merge!({:success => false,:errors => @news.errors})
      end
      result.to_json
    end
    
    # end news section
  
    # This is the home or root page. 
    get "/" do
      @news = News.tops
      page_title("Start")
      erb :index
    end

    # TODO - remove the textile stuff and add content to database.
    get "/mitmachen" do
      @content = read_file(content_file_path("info.textile")).to_textile
      page_title("Mitmachen")
      erb :static_page
    end
    
    # TODO - remove the textile stuff and implement a tiny player
    # management. 
    get "/mannschaft" do
      @team = read_file(content_file_path("team.textile")).to_textile
      page_title("Team")
      erb :team
      # get all players

      # get all officials

    end

    # TODO - remove this to more RESTful style.
    get "/spieler/:nummer/:name/:vorname" do

    end
    
    # TODO - remove the static content management, put in the db. 
    get "/halle" do
      # insert google maps for taucha and park5.1
      #page_title("Spielstätten")
      erb :static_page
    end

    # Gets the schedule of a given year. 
    # Schedule stuff is handled by BISHL gem
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
    
    # TODO deprectated. Should be removed if /news is done. 
    get "/fetch/data" do
      # fetch emails here and insert objects into db.
      MailOperator::import_news
    end

    # TODO deprecated. Should be removed if /news is done
    get "/cleanup" do
      MailOperator::delete_news
    end

    # Static document 'server'. This should be replaced by a
    # CarrierWave solution. 
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
    
  end
  
end