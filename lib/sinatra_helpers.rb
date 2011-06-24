 helpers do

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
      return "(Auswärts)"
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
        <img src='#{BISHL.logo_for(:team => opponent_id(game.first))}' width="100" height="100" />
        <p id="last_opponent">vs .#{opponent(game.first)}, #{result_line}</p>
        <div></div>
      </div>
      HTML
    end

  end

end